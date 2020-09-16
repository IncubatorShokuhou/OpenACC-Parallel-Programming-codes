program main
    implicit none
    real, parameter::widthy = 2.0, heightx = 1.0
    real hx, hy
    integer, parameter::mx = 8191, ny = 1023
    real(kind=4), allocatable::u0(:, :), u1(:, :)
    integer maxiter, iter, ix, jy
    real(kind=4) uerr, errtol
    real fij, c1, c2, hx2, hy2
    real tstart, tend
    real, external::uval
 
    maxiter = 10000
    errtol = 0.0
    hy = widthy/ny
    hx = heightx/mx
 
    allocate (u0(0:mx, 0:ny), u1(0:mx, 0:ny))  !保存二维格点的旧值和新值
 
    !Initalize the left/right boundary of u0/u1
    do ix = 0, mx
       u0(ix, 0) = uval(ix*hx, 0.0)
       u0(ix, ny) = uval(ix*hx, ny*hy)
    enddo
    u1(0:mx, 0) = u0(0:mx, 0)
    u1(0:mx, ny) = u0(0:mx, ny)
 
    !Initalize the upper/lower boundary of u0/u1
    do jy = 0, ny
       u0(0, jy) = uval(0.0, jy*hy)
       u0(mx, jy) = uval(mx*hx, jy*hy)
    enddo
    u1(0, 0:ny) = u0(0, 0:ny)
    u1(mx, 0:ny) = u0(mx, 0:ny)
 
    !Initalize the interior point of u0
    u0(1:mx - 1, 1:ny - 1) = 0.0
    fij = -4.
    c1 = hx*hx*hy*hy
    c2 = 1./(2.*(hx*hx + hy*hy))
    hx2 = hx*hx
    hy2 = hy*hy
    call cpu_time(tstart)
    ! main iterationsl
    !$acc data copyin(u0)   &
    !$acc      create(u1)   &
    !$acc      copyin(u1(0:mx,0),u1(0:mx,ny))   &
    !$acc      copyin(u1(0,1:ny-1),u1(mx,1:ny-1))   &
    !$acc      copyout(u1)
    do iter = 1, maxiter, 2
       !$acc kernels present(u0,u1)
       do jy = 1, ny - 1
          do ix = 1, mx - 1
             u1(ix, jy) = (fij*c1 + hy2*(u0(ix - 1, jy) + u0(ix + 1, jy)) + hx2*(u0(ix, jy - 1) + u0(ix, jy + 1)))*c2
          enddo
       enddo
       !$acc end kernels
       uerr = 0.0
       ! collapse子语合并多重循环
       ! 用于将多重小循环拼接成一个大循环，一边提高设备利用率
       !$acc kernels loop present(u0,u1) reduction(max:uerr) collapse(2)
       do jy = 1, ny - 1
          do ix = 1, mx - 1
             u0(ix, jy) = (fij*c1 + hy2*(u1(ix - 1, jy) + u1(ix + 1, jy)) + hx2*(u1(ix, jy - 1) + u1(ix, jy + 1)))*c2
             uerr = max(uerr,abs(u0(ix, jy)-u1(ix, jy)))
          enddo
       enddo
       !$acc end kernels
       print *, "iter=",iter+1,"uerr=",uerr 
       if (uerr < errtol) exit
    enddo
    !$acc end data
    call cpu_time(tend)
    print *, "ElapsedTime =", tend - tstart, " seconds"
    deallocate (u0, u1)
 end program
 !========================
 function uval(x, y)
    real, intent(in)::x, y
    uval = x*x + y*y
 end function
 
