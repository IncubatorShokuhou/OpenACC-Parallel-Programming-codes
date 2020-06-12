program main
#ifdef _OPENACC
    use openacc
#endif
implicit none
#ifdef _OPENACC
    print*, "Number of device:",&
        acc_get_num_devices(acc_device_not_host)
#else
    print*,"OpenAcc is not supported."
#endif
end program main