--Cleaning Data in Sql Queries

Select*
From [PortfolioProject].[dbo].[Nashville Housing]

--Standardize Date Format
Select SaleDate, Convert(Date, SaleDate) as SaleDate
From [PortfolioProject].[dbo].[Nashville Housing]

update [Nashville Housing]
Set SaleDate = Convert(Date, SaleDate)

--POPULATE PROPERTY ADDRESS DATA
Select PropertyAddress
From [PortfolioProject].[dbo].[Nashville Housing] --First, we check wehere the property address is not null
--so we perfrom the task to check
Select PropertyAddress
From [PortfolioProject].[dbo].[Nashville Housing]
where PropertyAddress is not null
-- Then repeat the process and order by parcelID to check for duplicates and if the parcelID is thesame as the propertyAddress
Select*
From [PortfolioProject].[dbo].[Nashville Housing]
order by ParcelID
--so its been found that, there are duplicates of parcelID and each of these duplicates are thesame as the propertyAddress, and there is need to populate the
--address, coz, the first parcelID owns the first property Address but the second ParcelD literally does not have an address and a need for populating it
--So,next, there is need to check for where there is null on the PropertyAddress, so it can be filled
--HENCE, we have to join the table to itself

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From [PortfolioProject].[dbo].[Nashville Housing] a
join [PortfolioProject].[dbo].[Nashville Housing] b
	on a.[ParcelID] = b.[ParcelID]
	and a.[UniqueID] <> b.[UniqueID]
	where a.PropertyAddress is null

-- so now we have the null in a.propertyAddress and so we have to make thesame address in b.propertyaddress reflect in a.propertyaddress.
--The we use the ISNULL syntax
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyAddress,b.PropertyAddress)
From [PortfolioProject].[dbo].[Nashville Housing] a
join [PortfolioProject].[dbo].[Nashville Housing] b
	on a.[ParcelID] = b.[ParcelID]
	and a.[UniqueID] <> b.[UniqueID]
	--where a.PropertyAddress is null

	--so we update it to reflect in the Nashville Housing table
	update a
	set PropertyAddress = isnull(a.propertyAddress,b.PropertyAddress)
	From [PortfolioProject].[dbo].[Nashville Housing] a
    join [PortfolioProject].[dbo].[Nashville Housing] b
	on a.[ParcelID] = b.[ParcelID]
	and a.[UniqueID] <> b.[UniqueID]
	where a.PropertyAddress is null
	
	--Breaking out Address into individual colomn (Address, City, State)
Select PropertyAddress
From [PortfolioProject].[dbo].[Nashville Housing]
--And because the addresses are separated by a coma, we will be introducing a substring and a charrindex
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE [PortfolioProject].[dbo].[Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

Update [PortfolioProject].[dbo].[Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProject.dbo.NashvilleHousing





Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE[PortfolioProject].[dbo].[Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [PortfolioProject].[dbo].[Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [PortfolioProject].[dbo].[Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

Update [PortfolioProject].[dbo].[Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [PortfolioProject].[dbo].[Nashville Housing]
Add OwnerSplitState Nvarchar(255);

Update [PortfolioProject].[dbo].[Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [PortfolioProject].[dbo].[Nashville Housing]


--Change Y and N to YES and NO in "Sold as Vacant" field

Select Distinct(SoldAsVacant)
From [PortfolioProject].[dbo].[Nashville Housing]

--check the count
Select Distinct(SoldAsVacant), count(SoldasVacant)
From [PortfolioProject].[dbo].[Nashville Housing]
group by SoldAsVacant
order by 2

--Since Yes And No has the most count, so we choose Yes and No
Select SoldasVacant
,CASE
	when soldasVacant = 'Y' then 'YES'
	when soldasVacant ='N' then 'NO'
	else SoldasVacant
	END
	From [PortfolioProject].[dbo].[Nashville Housing]

	update [PortfolioProject].[dbo].[Nashville Housing]
	SET SoldAsVacant = CASE
	when soldasVacant = 'Y' then 'YES'
	when soldasVacant ='N' then 'NO'
	else SoldasVacant
	END
	
	--Remove Duplicates
	With RowNumCTE as(
	select*,
	Row_number () over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
				 UniqueID
				 )
				 Row_num
				 From [PortfolioProject].[dbo].[Nashville Housing]
				 --order by ParcelID
				 )
				 select *
				 from RowNumCTE

	Select*
	From [PortfolioProject].[dbo].[Nashville Housing]

	-- Delete Unused Columns



Select*
From [PortfolioProject].[dbo].[Nashville Housing]


ALTER TABLE [PortfolioProject].[dbo].[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


--Extra Lesson to learn
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO




