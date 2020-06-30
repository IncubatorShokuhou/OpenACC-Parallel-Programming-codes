program deviceQuery
   use cudafor
   implicit none
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! used for showing infomation about CUDA device
! Example output:
! One CUDA device found
!
! Device Number: 0
!  Device Name: GeForce RTX 2080
!  Compute Capability: 7.5
!  Number of Multiprocessors: 46
!  Max Threads per Multiprocessor: 1024
!  Global Memory (GB):     7.792
!
!  Execution Configuration Limits
!  Max Grid Dims: 2147483647 x 65535 x 65535
!  Max Block Dims: 1024 x 1024 x 64
!  Max Threads per Block: 1024
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   type(cudaDeviceProp) :: prop
   integer :: nDevices = 0, i, ierr

! Number of CUDA -capable devices

   ierr = cudaGetDeviceCount(nDevices)

   if (nDevices == 0) then
      write (*, "(/,'No CUDA devices found ',/)")
      stop
   else if (nDevices == 1) then
      write (*, "(/,'One CUDA device found ',/)")
   else
      write (*, "(/,i0,' CUDA devices found ',/)") nDevices
   end if

   ! Loop over devices
   do i = 0, nDevices - 1

      write (*, "('Device Number: ',i0)") i

      ierr = cudaGetDeviceProperties(prop, i)

      ! General device info

      write (*, "(' Device Name: ',a)") trim(prop%name)
      write (*, "(' Compute Capability: ',i0,'.',i0)") &
         prop%major, prop%minor
      write (*, "(' Number of Multiprocessors: ',i0)") &
         prop%multiProcessorCount
      write (*, "(' Max Threads per Multiprocessor: ',i0)") &
         prop%maxThreadsPerMultiprocessor
      write (*, "(' Global Memory (GB): ',f9.3,/)") &
         prop%totalGlobalMem/1024.0**3

      ! Execution Configuration

      write (*, "(' Execution Configuration Limits ')")
      write (*, "(' Max Grid Dims: ',2(i0,' x '),i0)") &
         prop%maxGridSize
      write (*, "(' Max Block Dims: ',2(i0,' x '),i0)") &
         prop%maxThreadsDim
      write (*, "(' Max Threads per Block: ',i0 ,/)") &
         prop%maxThreadsPerBlock

   enddo

end program deviceQuery
