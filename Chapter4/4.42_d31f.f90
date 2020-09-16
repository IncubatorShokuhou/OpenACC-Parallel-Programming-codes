!pgf90 -acc -ta=multicore,tesla -Minfo -o d31f.exe  4.41_mod31.f90  4.42_d31f.f90
program main
    use staticmethod   !在module内已经声明了host上的xstat和yalloc,然后再declare在device上
    implicit none
    integer N 
    N = 2048
    call allocit(N)
    call compute(N)
    call deallocit()
end program

subroutine  allocit(N)
    use staticmethod   !子程序中访问的是同一个module内的内存空间/显存空间
    implicit none
    integer , intent(in)::N
    allocate(yalloc(N))
end subroutine allocit

subroutine  deallocit()
    use staticmethod
    implicit none
    if (allocated(yalloc)) then     !这里显式的deallocate了host内存的同时，也隐式地deallocate了device的内存
        deallocate(yalloc)
    end if
end subroutine deallocit

subroutine compute(N)
    use staticmethod
    implicit none
    integer , intent(in)::N
    integer length,idx 
    length = maxlen

    yalloc(1:N)  = 0.0
    !$acc kernels
    do idx = 1, length
        xstat(idx) = idx
    enddo
    do idx = 1, N
        yalloc(idx) = xstat(mod(idx,length)) + 1000
    enddo 
    !$acc end kernels
    print*,"h_yalloc(1:2)=", yalloc(1:2)
    !$acc update host(yalloc(1:2))
    print*,"d_yalloc(1:2)=", yalloc(1:2)
end subroutine compute