ColorApprox(color1,color2,perm:=4) ;argb
{
	r1 := (0x00ff0000 & color1) >> 16
	g1 := (0x0000ff00 & color1) >> 8
	b1 := 0x000000ff & color1
	r2 := (0x00ff0000 & color2) >> 16
	g2 := (0x0000ff00 & color2) >> 8
	b2 := 0x000000ff & color2
	if(abs(r1-r2)<=perm && abs(g1-g2)<=perm && abs(b1-b2)<=perm)
	return 1
	else
	return 0
}

ColorDarker(color1,color2,diff:=1) ;color1<color2 in ARGB
{
	r1 := (0x00ff0000 & color1) >> 16
	g1 := (0x0000ff00 & color1) >> 8
	b1 := 0x000000ff & color1
	
	r2 := (0x00ff0000 & color2) >> 16
	g2 := (0x0000ff00 & color2) >> 8
	b2 := 0x000000ff & color2
	if((r2-r1)>=diff && abs(g2-g1)>=diff && (b2-b1)>=diff)
	return 1
	else
	return 0
}

ArgbVectorEqual(v1,v2,perm:=1)
{
	if((v1.i_max!=v2.i_max)||(v1.w!=v2.w)||(v1.h!=v2.h))
	return -1
	
	Loop v1.i_max
	{
		if abs(v1.r_P[A_Index]-v2.r_P[A_Index])>perm
		return 0
		if abs(v1.g_P[A_Index]-v2.g_P[A_Index])>perm
		return 0
		if abs(v1.b_P[A_Index]-v2.b_P[A_Index])>perm
		return 0		
	}
	return 1
}