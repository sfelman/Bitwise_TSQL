USE [Sandbox]
GO

/****** Object:  UserDefinedFunction [dbo].[f_varbinary_xor]    Script Date: 10/9/2024 8:22:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[F_Varbinary_CIRCULAR_LEFT_SHIFT](
	@v varbinary(max),
	@left_shift int
)
returns varbinary(max)
with schemabinding
as
begin
	declare @varbin_parts table
	(
		left_byte bigint default(0),
		right_byte bigint default(0),
		o bigint null
	)
	declare @counter int = 1
	while @counter <= len(@v)
	begin
		insert into @varbin_parts (left_byte, right_byte)
		select convert(bigint, substring(LEFT_SHIFT(@v,@left_shift), @counter, 1)), convert(bigint,substring(RIGHT_SHIFT(@v,len(@v)*4-@left_shift), @counter, 1))
		set @counter = @counter + 1;
	end
	
	update @varbin_parts set o = left_byte | right_byte
	declare @result varbinary(max) = 0x
	select @result = @result + convert(varbinary(1),o) from @varbin_parts

	return @result
end
GO
