!非结构化数据生存周期
program main
    implicit none
    real,allocatable:: v1(:)
    integer length,idx

    length = 1024
    allocate(v1(length))
    v1(1:length)=0.0
    !$acc data copyin(v1(1:length))
    call add1(v1,length)           
    !$acc update host(v1(1:1))     
    print*, "v1(1) = ", v1(1)      !device上v1(1)=1, update到host上,  host上v1(1)=1
    v1(1) = v1(1) + 10             !host上v1(1)=1+10=11
    !$acc update device(v1(1:1))   !update更新到gpu
    call add1(v1,length)   
    !$acc update host(v1(1:1))       !device上v1(1)=12, update到host上,  host上v1(1)=12
    print*, "v1(1) = ", v1(1)      
    !$acc end data
    deallocate(v1)
endprogram

subroutine add1(vec,length)
    implicit none
    integer, intent(in)::length
    real,    intent(inout)::vec(1:length)
    integer idx
    !$acc parallel loop present(vec(1:length))
    do idx = 1, length
        vec(idx) = vec(idx) + idx
    enddo
    
end subroutine