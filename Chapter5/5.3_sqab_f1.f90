function  sqab(a)
    implicit none
    real sqab
    real,intent(in)::a
    sqab = sqrt(abs(a))
end function sqab