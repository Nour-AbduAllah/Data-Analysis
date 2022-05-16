--Sql data cleaning

--Select all data from NashvilleHousing db
Select * from NashvilleHousing; 

--Convert SaleDate column type from datetime to date
Alter Table NashvilleHousing
	Alter Column SaleDate Date;

--Check for Null data
Select ParcelID, PropertyAddress, OwnerName, OwnerAddress, Acreage, count(1) From NashvilleHousing 
	group by ParcelID, PropertyAddress, OwnerName, OwnerAddress, Acreage
	Order By ParcelID, PropertyAddress;

Select PropertyAddress From NashvilleHousing where PropertyAddress Is Null
	
--Fill null data in PropertyAddress Column from Duplication

Select T1.ParcelID, T1.PropertyAddress, T2.PropertyAddress
From NashvilleHousing T1
Inner Join NashvilleHousing T2
On T1.ParcelID = T2.ParcelID
and T1.PropertyAddress Is Null
Where T1.[UniqueID ] <> T2.[UniqueID ]

Update t1
Set t1.PropertyAddress = t2.PropertyAddress
From NashvilleHousing t1
Inner Join NashvilleHousing t2
On t1.ParcelID = t2.ParcelID
and t1.PropertyAddress Is Null
Where t1.[UniqueID ] <> t2.[UniqueID ]
	
--Drop null data in OwnerName
Delete from NashvilleHousing where OwnerName Is Null

--Split Property Address into district address and City
Select PropertyAddress,SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) [StreetAddress],
	Trim(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress) - CHARINDEX(',', PropertyAddress))) [City]
	From NashvilleHousing

Alter Table NashvilleHousing
Add PropertyDistrict nvarchar(50),
	PropertyCity nvarchar(50);
--Exec sp_rename 'dbo.NashvilleHousing.District', 'PropertyDistrict', 'COLUMN';
--Exec sp_rename 'dbo.NashvilleHousing.City', 'PropertyCity', 'Column';


--Adding 2 new columns (PropertyDistrict and PropertyCity).
Update NashvilleHousing
	Set PropertyDistrict = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
	PropertyCity = Trim(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress) - CHARINDEX(',', PropertyAddress)))

--Changes On SoldAsVacant column
Select Distinct SoldAsVacant, Count(*) [count] From NashvilleHousing Group By SoldAsVacant

/*Update N1
	Set N1.SoldAsVacant = N2.SoldAsVacant
	from NashvilleHousing N1 
	Inner Join Nashville N2 
	on N1.ParcelID = N2.ParcelID
	Where N1.[UniqueID ] = N2.[UniqueID ]*/

Update NashvilleHousing
	Set SoldAsVacant = 
	Case
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End




--Remove Duplicates
--Create a common table expression to detect duplicates using window function
With DuplicatesCTE As(
	Select ROW_NUMBER() 
	Over(
	Partition By ParcelID, LandUse, PropertyAddress, SaleDate,
	SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress,
	Acreage, TaxDistrict, LandValue, TotalValue, YearBuilt,
	BedRooms, FullBath, HalfBath Order by ParcelID)[RowRank]
	From NashvilleHousing
)
Delete from DuplicatesCTE where [RowRank] > 1



--Drop useless columns
Alter Table NashvilleHousing
Drop Column PropertyAddress, OwnerAddress, TaxDistrict

