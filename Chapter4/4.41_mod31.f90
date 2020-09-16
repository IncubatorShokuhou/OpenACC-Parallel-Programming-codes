module staticmethod
    implicit none
    integer, parameter::maxlen= 1024
    real xstat(maxlen)
    real,allocatable::yalloc(:)
    !$acc declare create(xstat,yalloc)
end module staticmethod