!非结构化数据生存周期
program main
    implicit none
    real,allocatable:: v1(:)
    integer length,idx

    length = 1024
    allocate(v1(length))
    v1(1:length)=0.0
    !$acc enter data copyin(v1(1:length))

    call add1(v1,length)           !实参是v1,形参是vec,名字不同但代表了同一个host上内存地址.  update的对象实际上是host内存中特定地址所代表的数据
    !$acc update host(v1(1:1))     !所以在这里可以用update更新到gpu.  update语句也可以放到子函数里
    print*, "v1(1) = ", v1(1)      !设备上v1(1)=1, update到host上,  host上v1(1)=1

    call add1(v1,length)   
    !$acc update host(v1(1:1))
    print*, "v1(1) = ", v1(1)      !设备上v1(1)=2, update到host上,  host上v1(1)=2

    !$acc exit data delete(v1)
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