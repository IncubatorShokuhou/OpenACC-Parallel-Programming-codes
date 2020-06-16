program main
    implicit none
    integer h(0:9)  ,length,idx
    integer, allocatable:: vec(:)
    real rdn
    length = 1024
    h(:)=0
    allocate(vec(length))
    call random_seed()
    do idx=1,length
        call random_number(rdn)
        vec(idx)=int(rdn*10)
    enddo
    !$acc parallel 
    !$acc loop
    do idx= 1,length
        !$acc atomic update
        h(vec(idx)) = h(vec(idx))+1
    enddo
    !$acc end parallel
    print*,"h=",h(0:9)
    deallocate(vec)
end program