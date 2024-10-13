USE [Sandbox]
GO

/****** Object:  UserDefinedFunction [dbo].[f_varbinary_xor]    Script Date: 10/9/2024 8:22:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[F_Varbinary_NOT](
	@v varbinary(max)
)
returns varbinary(max)
with schemabinding
as
begin
	

	declare @varbin_parts table
	(
		value_byte bigint default(0),
		value_not bigint null
	)
	declare @counter int = 1
	while @counter <= len(@v)
	begin
		insert into @varbin_parts (value_byte)
		select convert(bigint, substring(@v, @counter, 1))
		set @counter = @counter + 1;
	end
	
	update @varbin_parts set value_not = ~value_byte 
	declare @result varbinary(max) = 0x
	select @result = @result + convert(varbinary(1),value_not) from @varbin_parts
	
	return @result

end
GO


