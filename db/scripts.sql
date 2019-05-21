USE [master]
GO
/****** Object:  Database [veriff]    Script Date: 05/21/2019 16:32:49 ******/
CREATE DATABASE [veriff] ON  PRIMARY 
( NAME = N'veriff', FILENAME = N'C:\Data\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\veriff.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'veriff_log', FILENAME = N'C:\Data\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\veriff_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [veriff] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [veriff].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [veriff] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [veriff] SET ANSI_NULLS OFF
GO
ALTER DATABASE [veriff] SET ANSI_PADDING OFF
GO
ALTER DATABASE [veriff] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [veriff] SET ARITHABORT OFF
GO
ALTER DATABASE [veriff] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [veriff] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [veriff] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [veriff] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [veriff] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [veriff] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [veriff] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [veriff] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [veriff] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [veriff] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [veriff] SET  DISABLE_BROKER
GO
ALTER DATABASE [veriff] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [veriff] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [veriff] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [veriff] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [veriff] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [veriff] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [veriff] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [veriff] SET  READ_WRITE
GO
ALTER DATABASE [veriff] SET RECOVERY SIMPLE
GO
ALTER DATABASE [veriff] SET  MULTI_USER
GO
ALTER DATABASE [veriff] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [veriff] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'veriff', N'ON'
GO
USE [veriff]
GO
/****** Object:  User [veriff]    Script Date: 05/21/2019 16:32:49 ******/
CREATE USER [veriff] FOR LOGIN [veriff] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[points]    Script Date: 05/21/2019 16:32:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[points](
	[point_id] [int] NOT NULL,
	[point_name] [varchar](50) NOT NULL,
	[point_country] [char](2) NOT NULL,
	[point_city] [varchar](50) NOT NULL,
	[point_address] [varchar](200) NOT NULL,
	[point_phone] [varchar](20) NOT NULL,
	[airport_name] [varchar](50) NULL,
 CONSTRAINT [PK_points] PRIMARY KEY CLUSTERED 
(
	[point_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[get_text_date]    Script Date: 05/21/2019 16:32:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_text_date](
  @date date
)
returns varchar(16)
as
begin
  declare @result varchar(16)
  set @result = replace(convert(varchar(11), @date, 0), '  ', ' ')
  if (year(@date) = year(getdate()))
  begin
    set @result = substring(@result, 1, 6)
  end
  set @result = substring(datename(dw, @date), 1, 3) + ', ' + @result
  return @result
end
GO
/****** Object:  Table [dbo].[benefits]    Script Date: 05/21/2019 16:32:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[benefits](
	[benefit_id] [int] NOT NULL,
	[benefit_description] [varchar](50) NOT NULL,
	[is_important] [bit] NOT NULL,
 CONSTRAINT [PK_benefits] PRIMARY KEY CLUSTERED 
(
	[benefit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[users]    Script Date: 05/21/2019 16:32:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] NOT NULL,
	[login] [varchar](128) NOT NULL,
	[pass] [char](64) NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
	[birth_date] [date] NULL,
	[document_number] [varchar](20) NULL,
	[document_type] [int] NULL,
	[document_country] [char](2) NULL,
	[document_valid_from] [date] NULL,
	[document_valid_until] [date] NULL,
	[status] [varchar](50) NOT NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PASSPORT=1, ID_CARD=2, DRIVERS_LICENCE=3, RESIDENCE_PERMIT=4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'users', @level2type=N'COLUMN',@level2name=N'document_type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'approved, resubmission_requested, declined, expired, abandoned' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'users', @level2type=N'COLUMN',@level2name=N'status'
GO
/****** Object:  StoredProcedure [dbo].[sp_users_update]    Script Date: 05/21/2019 16:32:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_users_update] (
  @user_id int,
  @login varchar(128) = null,
  @pass char(64) = null,
  @first_name varchar(50) = null,
  @last_name varchar(50) = null,
  @birth_date date = null,
  @document_number varchar(20) = null,
  @document_type int = null, /* PASSPORT=1, ID_CARD=2, DRIVERS_LICENCE=3, RESIDENCE_PERMIT=4 */
  @document_country char(2) = null,
  @document_valid_from date = null,
  @document_valid_until date = null,
  @status varchar(50) = null
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        users
      set
        [login] = case when @login is null then [login] else @login end,       
        [pass] = case when @pass is null then [pass] else @pass end,       
        [first_name] = case when @first_name is null then [first_name] else @first_name end,       
        [last_name] = case when @last_name is null then [last_name] else @last_name end,       
        [birth_date] = case when @birth_date is null then [birth_date] else @birth_date end,       
        [document_number] = case when @document_number is null then [document_number] else @document_number end,       
        [document_type] = case when @document_type is null then [document_type] else @document_type end,       
        [document_country] = case when @document_country is null then [document_country] else @document_country end,       
        [document_valid_from] = case when @document_valid_from is null then [document_valid_from] else @document_valid_from end,       
        [document_valid_until] = case when @document_valid_until is null then [document_valid_until] else @document_valid_until end,
        [status] = case when @status is null then [status] else @status end
      where
        ([user_id] = @user_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [update users]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end
GO
/****** Object:  StoredProcedure [dbo].[sp_users_insert]    Script Date: 05/21/2019 16:32:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
  Процедура: sp_users_insert
  Добавляет данные в таблицу users ()
*/

CREATE PROCEDURE [dbo].[sp_users_insert] (
  @user_id int OUTPUT,
  @login varchar(128),
  @pass char(64),
  @first_name varchar(50),
  @last_name varchar(50)
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    if @user_id is null select @user_id = isnull(max([user_id]), 0)+1 from users
    insert
      into
        users
      (
        [user_id],
        [login],
        [pass],
        [first_name],
        [last_name]
      ) 
      values
      (
        @user_id,
        @login,
        @pass,
        @first_name,
        @last_name
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [insert into users]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_users_delete]    Script Date: 05/21/2019 16:32:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_users_delete] (
  @user_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    delete
      from
        users
      where
        ([user_id] = @user_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [delete from users]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  View [dbo].[vw_points]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_points] (
  [point_id],
  [point_name],
  [point_country],
  [point_city],
  [point_output_city],
  [point_address],
  [point_phone],
  [airport_name],
  [is_airport]
)
AS
  select 
    [point_id],
    [point_name],
    [point_country],
    [point_city],
    left(point_city, charindex(',', point_city)) + ' ' + point_country + (case when [airport_name] is not null then ' (' + airport_name + ' airport)' else '' end),
    [point_address],
    [point_phone],
    isnull([airport_name], ''),
    convert(bit, case when [airport_name] is null then 0 else 1 end)
  from
    points
GO
/****** Object:  View [dbo].[vw_benefits]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_benefits] (
  [benefit_id],
  [benefit_description],
  [is_important]
)
AS
  select 
    [benefit_id],
    [benefit_description],
    [is_important]
  from
    benefits
GO
/****** Object:  View [dbo].[vw_users]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_users] (
  [user_id],
  [login],
  [pass],
  [first_name],
  [last_name],
  [birth_date],
  [document_number],
  [document_type], /* PASSPORT=1, ID_CARD=2, DRIVERS_LICENCE=3, RESIDENCE_PERMIT=4 */
  [document_country],
  [document_valid_from],
  [document_valid_until],
  [status]
)
AS
  select 
    [user_id],
    [login],
    [pass],
    [first_name],
    [last_name],
    [birth_date],
    [document_number],
    [document_type],
    [document_country],
    [document_valid_from],
    [document_valid_until],
    [status]
  from
    users
GO
/****** Object:  Table [dbo].[cars]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cars](
	[car_id] [int] NOT NULL,
	[point_id] [int] NULL,
	[car_type] [varchar](10) NOT NULL,
	[car_name] [varchar](50) NOT NULL,
	[passengers] [tinyint] NOT NULL,
	[bags] [tinyint] NOT NULL,
	[doors] [varchar](5) NOT NULL,
	[price_per_day] [money] NOT NULL,
	[is_has_ac] [bit] NOT NULL,
	[is_electric] [bit] NOT NULL,
	[transmission_type] [varchar](20) NOT NULL,
 CONSTRAINT [PK_cars] PRIMARY KEY CLUSTERED 
(
	[car_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Small, Medium, Large, SUV, Van' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cars', @level2type=N'COLUMN',@level2name=N'car_type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Automatic, Manual' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cars', @level2type=N'COLUMN',@level2name=N'transmission_type'
GO
/****** Object:  StoredProcedure [dbo].[sp_points_update]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_points_update] (
  @point_id int,
  @point_name varchar(50) = null,
  @point_country char(2) = null,
  @point_city varchar(50) = null,
  @point_address varchar(200) = null,
  @point_phone varchar(20) = null,
  @airport_name varchar(50)
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        points
      set
        [point_name] = case when @point_name is null then [point_name] else @point_name end,       
        [point_country] = case when @point_country is null then [point_country] else @point_country end,       
        [point_city] = case when @point_city is null then [point_city] else @point_city end,       
        [point_address] = case when @point_address is null then [point_address] else @point_address end,       
        [point_phone] = case when @point_phone is null then [point_phone] else @point_phone end,       
        [airport_name] = @airport_name
      where
        ([point_id] = @point_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [update points]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end
GO
/****** Object:  StoredProcedure [dbo].[sp_points_insert]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_points_insert] (
  @point_id int OUTPUT,
  @point_name varchar(50),
  @point_country char(2),
  @point_city varchar(50),
  @point_address varchar(200),
  @point_phone varchar(20),
  @airport_name varchar(50)
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    if @point_id is null select @point_id = isnull(max([point_id]), 0)+1 from points
    insert
      into
        points
      (
        [point_id],
        [point_name],
        [point_country],
        [point_city],
        [point_address],
        [point_phone],
        [airport_name]
      ) 
      values
      (
        @point_id,
        @point_name,
        @point_country,
        @point_city,
        @point_address,
        @point_phone,
        @airport_name
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [insert into points]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_points_delete]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_points_delete] (
  @point_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    delete
      from
        points
      where
        ([point_id] = @point_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [delete from points]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_benefits_update]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_benefits_update] (
  @benefit_id int,
  @benefit_description varchar(50) = null,
  @is_important bit = null
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        benefits
      set
        [benefit_description] = case when @benefit_description is null then [benefit_description] else @benefit_description end,
        [is_important] = case when @is_important is null then [is_important] else @is_important end
      where
        ([benefit_id] = @benefit_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [update benefits]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end
GO
/****** Object:  StoredProcedure [dbo].[sp_benefits_insert]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_benefits_insert] (
  @benefit_id int OUTPUT,
  @benefit_description varchar(50),
  @is_important bit
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    if @benefit_id is null select @benefit_id = isnull(max([benefit_id]), 0)+1 from benefits
    insert
      into
        benefits
      (
        [benefit_id],
        [benefit_description],
        [is_important]
      ) 
      values
      (
        @benefit_id,
        @benefit_description,
        @is_important
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [insert into benefits]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_benefits_delete]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_benefits_delete] (
  @benefit_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    delete
      from
        benefits
      where
        ([benefit_id] = @benefit_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [delete from benefits]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  Table [dbo].[sessions]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sessions](
	[session_id] [char](36) NOT NULL,
	[user_id] [int] NOT NULL,
	[status] [varchar](50) NOT NULL,
	[url] [varchar](512) NOT NULL,
	[reason] [varchar](50) NULL,
 CONSTRAINT [PK_sessions] PRIMARY KEY CLUSTERED 
(
	[session_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[rent]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rent](
	[rent_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[car_id] [int] NOT NULL,
	[point_id_from] [int] NOT NULL,
	[point_id_to] [int] NOT NULL,
	[rent_from] [date] NOT NULL,
	[rent_until] [date] NOT NULL,
	[price_total] [money] NOT NULL,
	[is_returned] [bit] NOT NULL,
 CONSTRAINT [PK_rent] PRIMARY KEY CLUSTERED 
(
	[rent_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_cars_update]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_cars_update] (
  @car_id int,
  @point_id int,
  @car_type varchar(10) = null, /* Small, Medium, Large, SUV, Van */
  @car_name varchar(50) = null,
  @passengers tinyint = null,
  @bags tinyint = null,
  @doors varchar(5) = null,
  @price_per_day money = null,
  @is_has_ac bit = null,
  @is_electric bit = null,
  @transmission_type varchar(20) = null /* Automatic, Manual */
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        cars
      set
        [point_id] = @point_id,       
        [car_type] = case when @car_type is null then [car_type] else @car_type end,       
        [car_name] = case when @car_name is null then [car_name] else @car_name end,       
        [passengers] = case when @passengers is null then [passengers] else @passengers end,       
        [bags] = case when @bags is null then [bags] else @bags end,       
        [doors] = case when @doors is null then [doors] else @doors end,       
        [price_per_day] = case when @price_per_day is null then [price_per_day] else @price_per_day end,       
        [is_has_ac] = case when @is_has_ac is null then [is_has_ac] else @is_has_ac end,       
        [is_electric] = case when @is_electric is null then [is_electric] else @is_electric end,       
        [transmission_type] = case when @transmission_type is null then [transmission_type] else @transmission_type end
      where
        ([car_id] = @car_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [update cars]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end
GO
/****** Object:  StoredProcedure [dbo].[sp_cars_insert]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
  Процедура: sp_cars_insert
  Добавляет данные в таблицу cars ()
*/

CREATE PROCEDURE [dbo].[sp_cars_insert] (
  @car_id int OUTPUT,
  @point_id int,
  @car_type varchar(10), /* Small, Medium, Large, SUV, Van */
  @car_name varchar(50),
  @passengers tinyint,
  @bags tinyint,
  @doors varchar(5),
  @price_per_day money,
  @is_has_ac bit,
  @is_electric bit,
  @transmission_type varchar(20) /* Automatic, Manual */
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    if @car_id is null select @car_id = isnull(max([car_id]), 0)+1 from cars
    insert
      into
        cars
      (
        [car_id],
        [point_id],
        [car_type],
        [car_name],
        [passengers],
        [bags],
        [doors],
        [price_per_day],
        [is_has_ac],
        [is_electric],
        [transmission_type]
      ) 
      values
      (
        @car_id,
        @point_id,
        @car_type,
        @car_name,
        @passengers,
        @bags,
        @doors,
        @price_per_day,
        @is_has_ac,
        @is_electric,
        @transmission_type
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [insert into cars]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_cars_delete]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_cars_delete] (
  @car_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    delete
      from
        cars
      where
        ([car_id] = @car_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [delete from cars]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  View [dbo].[vw_sessions]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_sessions] (
  [session_id],
  [user_id],
  [status],
  [url],
  [reason]
)
AS
  select 
    [session_id],
    [user_id],
    [status],
    [url],
    isnull([reason], '')
  from
    sessions
GO
/****** Object:  Table [dbo].[cars_benefits]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cars_benefits](
	[car_id] [int] NOT NULL,
	[benefit_id] [int] NOT NULL,
 CONSTRAINT [PK_cars_benefits] PRIMARY KEY CLUSTERED 
(
	[car_id] ASC,
	[benefit_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_sessions_update]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_sessions_update] (
  @session_id char(36),
  @user_id int = null,
  @status varchar(50) = null,
  @url varchar(512) = null,
  @reason varchar(50) = null
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        sessions
      set
        [user_id] = case when @user_id is null then [user_id] else @user_id end,       
        [status] = case when @status is null then [status] else @status end,       
        [url] = case when @url is null then [url] else @url end,       
        [reason] = case when @reason is null then [reason] else @reason end
      where
        ([session_id] = @session_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [update sessions]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error
    
    if (@user_id is null)
      select @user_id = [user_id] from sessions where session_id = @session_id
    exec sp_users_update @user_id = @user_id, @status = @status

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end
GO
/****** Object:  StoredProcedure [dbo].[sp_sessions_insert]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_sessions_insert] (
  @session_id char(36),
  @user_id int,
  @status varchar(50),
  @url varchar(512)
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    insert
      into
        sessions
      (
        [session_id],
        [user_id],
        [status],
        [url]
      ) 
      values
      (
        @session_id,
        @user_id,
        @status,
        @url
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [insert into sessions]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_sessions_delete]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_sessions_delete] (
  @session_id char(36)
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    delete
      from
        sessions
      where
        ([session_id] = @session_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [delete from sessions]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_rent_update]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_rent_update] (
  @rent_id int,
  @user_id int = null,
  @car_id int = null,
  @point_id_from int = null,
  @point_id_to int = null,
  @rent_from date = null,
  @rent_until date = null,
  @price_total money = null,
  @is_returned bit = null
)
AS
begin
  SET NOCOUNT ON

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    update
        rent
      set
        [user_id] = case when @user_id is null then [user_id] else @user_id end,       
        [car_id] = case when @car_id is null then [car_id] else @car_id end,       
        [point_id_from] = case when @point_id_from is null then [point_id_from] else @point_id_from end,       
        [point_id_to] = case when @point_id_to is null then [point_id_to] else @point_id_to end,       
        [rent_from] = case when @rent_from is null then [rent_from] else @rent_from end,       
        [rent_until] = case when @rent_until is null then [rent_until] else @rent_until end,       
        [price_total] = case when @price_total is null then [price_total] else @price_total end,
        [is_returned] = case when @is_returned is null then [is_returned] else @is_returned end
      where
        ([rent_id] = @rent_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [update rent]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end

end
GO
/****** Object:  StoredProcedure [dbo].[sp_rent_insert]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_rent_insert] (
  @rent_id int OUTPUT,
  @user_id int,
  @car_id int,
  @point_id_from int,
  @point_id_to int,
  @rent_from date,
  @rent_until date,
  @price_total money
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    if @rent_id is null select @rent_id = isnull(max([rent_id]), 0)+1 from rent
    insert
      into
        rent
      (
        [rent_id],
        [user_id],
        [car_id],
        [point_id_from],
        [point_id_to],
        [rent_from],
        [rent_until],
        [price_total]
      ) 
      values
      (
        @rent_id,
        @user_id,
        @car_id,
        @point_id_from,
        @point_id_to,
        @rent_from,
        @rent_until,
        @price_total
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [insert into rent]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_rent_delete]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_rent_delete] (
  @rent_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    delete
      from
        rent
      where
        ([rent_id] = @rent_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [delete from rent]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  View [dbo].[vw_cars_benefits]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_cars_benefits] (
  [car_id],
  [benefit_id],
  [benefit_description],
  [is_important]
)
AS
  select 
    [car_id],
    cb.[benefit_id],
    b.[benefit_description],
    b.[is_important]
  from
    cars_benefits cb
    inner join benefits b on cb.[benefit_id] = b.[benefit_id]
GO
/****** Object:  StoredProcedure [dbo].[sp_cars_benefits_insert]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_cars_benefits_insert] (
  @car_id int,
  @benefit_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    insert
      into
        cars_benefits
      (
        [car_id],
        [benefit_id]
      ) 
      values
      (
        @car_id,
        @benefit_id
      )

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [insert into cars_benefits]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_cars_benefits_delete]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_cars_benefits_delete] (
  @car_id int,
  @benefit_id int
)
AS
begin
  set nocount on

  declare @proc_error varchar(10), @proc_name varchar(50), @proc_message varchar(200)
  set @proc_name = object_name(@@PROCID)
  set @proc_error = '0'

  begin tran
    delete
      from
        cars_benefits
      where
        ([car_id] = @car_id) and ([benefit_id] = @benefit_id)

    set @proc_error = convert(varchar(10), @@ERROR)
    if @@ERROR <> 0
    begin
      execute master..xp_sprintf @proc_message OUTPUT,
        'Error! Proc: %s, code: %s [delete from cars_benefits]', @proc_name, @proc_error 
      print @proc_message
      rollback tran
      return convert(int, @proc_error)
    end -- if @proc_error

  if @proc_error = '0' 
  begin
    commit tran
    return 0
  end
  else
  begin
    rollback tran
    execute master..xp_sprintf @proc_message OUTPUT,
      'Error! Proc: %s, code: %s', @proc_name, @proc_error 
    print @proc_message
    return convert(int, @proc_error)
  end
end
GO
/****** Object:  UserDefinedFunction [dbo].[get_rented_cars]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_rented_cars](@datefrom date, @dateto date)
  returns table
as
return (
  select distinct car_id
    from rent
    where (rent_from between @datefrom and @dateto) or (rent_until between @datefrom and @dateto) and is_returned = 0
)
GO
/****** Object:  UserDefinedFunction [dbo].[get_car_benefits]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_car_benefits](
  @car_id int
)
returns varchar(1000)
as
begin
  declare @result varchar(1000)
  set @result = ''
  select @result = @result + '|' + case when is_important = 1 then '+' else '' end + benefit_description
    from vw_cars_benefits
    where car_id = @car_id
  return substring(@result, 2, len(@result))
end
GO
/****** Object:  View [dbo].[vw_cars]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_cars] (
  [car_id],
  [point_id],
  [point_name],
  [point_country],
  [point_city],
  [point_address],
  [point_phone],
  [airport_name],
  [is_airport],
  [car_type], /* Small, Medium, Large, SUV, Van */
  [car_name],
  [passengers],
  [bags],
  [doors],
  [price_per_day],
  [is_has_ac],
  [is_electric],
  [transmission_type], /* Automatic, Manual */
  [is_rented],
  [car_benefits]
)
AS
  select 
    [car_id],
    c.[point_id],
    isnull([point_name], ''),
    isnull([point_country], ''),
    isnull([point_city], ''),
    isnull([point_address], ''),
    isnull([point_phone], ''),
    isnull([airport_name], ''),
    isnull([is_airport], 0),
    [car_type],
    [car_name],
    [passengers],
    [bags],
    [doors],
    [price_per_day],
    [is_has_ac],
    [is_electric],
    [transmission_type],
    convert(bit, case when c.point_id is null then 1 else 0 end),
    dbo.[get_car_benefits](car_id)
  from
    cars c
    left outer join vw_points p on c.[point_id] = p.[point_id]
GO
/****** Object:  View [dbo].[vw_rent]    Script Date: 05/21/2019 16:32:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_rent] (
  [rent_id],
  [user_id],
  [user_first_name],
  [user_last_name],
  [user_birth_date],
  [user_document_number],
  [car_id],
  [car_type], /* Small, Medium, Large, SUV, Van */
  [car_name],
  [car_passengers],
  [car_bags],
  [car_doors],
  [car_is_has_ac],
  [car_is_electric],
  [car_transmission_type], /* Automatic, Manual, Robotic */
  [car_benefits],
  [point_id_from],
  [from_name],
  [from_country],
  [from_city],
  [from_address],
  [from_phone],
  [from_airport_name],
  [from_is_airport],
  [point_id_to],
  [to_name],
  [to_country],
  [to_city],
  [to_address],
  [to_phone],
  [to_airport_name],
  [to_is_airport],
  [rent_from],
  [text_rent_from],
  [rent_until],
  [text_rent_until],
  [price_total],
  [is_returned]
)
AS
  select 
    [rent_id],
    r.[user_id],
    [first_name],
    [last_name],
    [birth_date],
    [document_number],
    r.[car_id],
    [car_type],
    [car_name],
    [passengers],
    [bags],
    [doors],
    [is_has_ac],
    [is_electric],
    [transmission_type],
    [car_benefits],
    r.[point_id_from],
    pf.[point_name],
    pf.[point_country],
    pf.[point_city],
    pf.[point_address],
    pf.[point_phone],
    pf.[airport_name],
    pf.[is_airport],
    r.[point_id_to],
    pt.[point_name],
    pt.[point_country],
    pt.[point_city],
    pt.[point_address],
    pt.[point_phone],
    pt.[airport_name],
    pt.[is_airport],
    [rent_from],
    dbo.get_text_date([rent_from]),
    [rent_until],
    dbo.get_text_date([rent_until]),
    [price_total],
    is_returned
  from
    rent r
    inner join vw_users u on u.[user_id] = r.[user_id]
    inner join vw_cars c on c.[car_id] = r.[car_id]
    inner join vw_points pf on pf.[point_id] = r.[point_id_from]
    inner join vw_points pt on pt.[point_id] = r.[point_id_to]
GO
/****** Object:  Default [DF_benefits_is_important]    Script Date: 05/21/2019 16:32:51 ******/
ALTER TABLE [dbo].[benefits] ADD  CONSTRAINT [DF_benefits_is_important]  DEFAULT ((0)) FOR [is_important]
GO
/****** Object:  Default [DF_users_status]    Script Date: 05/21/2019 16:32:51 ******/
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_status]  DEFAULT ('') FOR [status]
GO
/****** Object:  Default [DF_rent_is_returned]    Script Date: 05/21/2019 16:32:53 ******/
ALTER TABLE [dbo].[rent] ADD  CONSTRAINT [DF_rent_is_returned]  DEFAULT ((0)) FOR [is_returned]
GO
/****** Object:  ForeignKey [FK_cars_points]    Script Date: 05/21/2019 16:32:53 ******/
ALTER TABLE [dbo].[cars]  WITH CHECK ADD  CONSTRAINT [FK_cars_points] FOREIGN KEY([point_id])
REFERENCES [dbo].[points] ([point_id])
GO
ALTER TABLE [dbo].[cars] CHECK CONSTRAINT [FK_cars_points]
GO
/****** Object:  ForeignKey [FK_sessions_users]    Script Date: 05/21/2019 16:32:53 ******/
ALTER TABLE [dbo].[sessions]  WITH CHECK ADD  CONSTRAINT [FK_sessions_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[sessions] CHECK CONSTRAINT [FK_sessions_users]
GO
/****** Object:  ForeignKey [FK_rent_cars]    Script Date: 05/21/2019 16:32:53 ******/
ALTER TABLE [dbo].[rent]  WITH CHECK ADD  CONSTRAINT [FK_rent_cars] FOREIGN KEY([car_id])
REFERENCES [dbo].[cars] ([car_id])
GO
ALTER TABLE [dbo].[rent] CHECK CONSTRAINT [FK_rent_cars]
GO
/****** Object:  ForeignKey [FK_rent_points_from]    Script Date: 05/21/2019 16:32:53 ******/
ALTER TABLE [dbo].[rent]  WITH CHECK ADD  CONSTRAINT [FK_rent_points_from] FOREIGN KEY([point_id_from])
REFERENCES [dbo].[points] ([point_id])
GO
ALTER TABLE [dbo].[rent] CHECK CONSTRAINT [FK_rent_points_from]
GO
/****** Object:  ForeignKey [FK_rent_points_to]    Script Date: 05/21/2019 16:32:53 ******/
ALTER TABLE [dbo].[rent]  WITH CHECK ADD  CONSTRAINT [FK_rent_points_to] FOREIGN KEY([point_id_to])
REFERENCES [dbo].[points] ([point_id])
GO
ALTER TABLE [dbo].[rent] CHECK CONSTRAINT [FK_rent_points_to]
GO
/****** Object:  ForeignKey [FK_rent_users]    Script Date: 05/21/2019 16:32:53 ******/
ALTER TABLE [dbo].[rent]  WITH CHECK ADD  CONSTRAINT [FK_rent_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[rent] CHECK CONSTRAINT [FK_rent_users]
GO
/****** Object:  ForeignKey [FK_cars_benefits_benefits]    Script Date: 05/21/2019 16:32:53 ******/
ALTER TABLE [dbo].[cars_benefits]  WITH CHECK ADD  CONSTRAINT [FK_cars_benefits_benefits] FOREIGN KEY([benefit_id])
REFERENCES [dbo].[benefits] ([benefit_id])
GO
ALTER TABLE [dbo].[cars_benefits] CHECK CONSTRAINT [FK_cars_benefits_benefits]
GO
/****** Object:  ForeignKey [FK_cars_benefits_cars]    Script Date: 05/21/2019 16:32:53 ******/
ALTER TABLE [dbo].[cars_benefits]  WITH CHECK ADD  CONSTRAINT [FK_cars_benefits_cars] FOREIGN KEY([car_id])
REFERENCES [dbo].[cars] ([car_id])
GO
ALTER TABLE [dbo].[cars_benefits] CHECK CONSTRAINT [FK_cars_benefits_cars]
GO
