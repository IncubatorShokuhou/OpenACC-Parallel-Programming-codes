!非结构化数据生存周期
program main
    implicit none
    real,allocatable:: v1(:)
    integer length,idx

    length = 1024
    allocate(v1(length))
    v1(1:length)=0.0
    !$acc enter data copyin(v1(1:length))
    !$acc parallel loop present(v1(1:length))
    do idx = 1, length
        v1(idx) = v1(idx) + idx    !设备上v1(1)=1, host上v1(1)=0   
    enddo

    !$acc update host(v1(1:1))     !可以指定不连续的子数组
    print*, "v1(1) = ", v1(1)      !设备上v1(1)=1, update到host上,  host上v1(1)=1

    !$acc parallel loop present(v1(1:length))
    do idx = 1, length
        v1(idx) = v1(idx) + idx    !设备上v1(1)=2,   host上v1(1)=1
    enddo

    !$acc update host(v1(1:1))
    print*, "v1(1) = ", v1(1)      !设备上v1(1)=2, update到host上,  host上v1(1)=2

    !$acc exit data delete(v1)
    deallocate(v1)
endprogram