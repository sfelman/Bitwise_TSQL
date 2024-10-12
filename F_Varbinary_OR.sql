USE [Sandbox]
GO

/****** Object:  UserDefinedFunction [dbo].[f_varbinary_xor]    Script Date: 10/9/2024 8:22:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[F_Varbinary_OR](
	@v1 varbinary(max)
	,@v2 varbinary(max)
)
returns varbinary(max)
with schemabinding
as
begin
	declare @lenv1 int = len(@v1), @lenv2 int = len(@v2)
	declare @bytes int = greatest(@lenv1,@lenv2)
	declare @dif int, @i int
	if(@lenv1>@lenv2)
	begin
		set @dif = @lenv1 - @lenv2
		set @i = 1
		while (@i <= @dif)
		begin
			set @v2 = cast(0 as varbinary(1))+@v2
			set @i = @i+1
		end
	end
	if(@lenv2>@lenv1)
	begin
		set @dif = @lenv2 - @lenv1
		set @i = 1
		while (@i <= @dif)
		begin
			set @v1 = cast(0 as varbinary(1))+@v1
			set @i = @i+1
		end
	end

	declare @varbin_parts table
	(
		value1_byte bigint default(0),
		value2_byte bigint default(0),
		o bigint null
	)
	declare @counter int = 1
	while @counter <= @bytes
	begin
		insert into @varbin_parts (value1_byte, value2_byte)
		select convert(bigint, substring(@v1, @counter, 1)), convert(bigint,substring(@v2, @counter, 1))
		set @counter = @counter + 1;
	end
	
	update @varbin_parts set o = value1_byte | value2_byte
	declare @result varbinary(max) = 0x
	select @result = @result + convert(varbinary(1),o) from @varbin_parts
	
	return @result

end
GO


