/*

Cleaning Data in SQL Queries

*/

Select * 
from PortfolioProject..[NashvilleHousing]



-------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
Select SaleDate, CONVERT(Date, SaleDate)
from PortfolioProject.. [NashvilleHousing]

Update [NashvilleHousing]
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted =  CONVERT(Date,SaleDate)



-------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
from PortfolioProject..[NashvilleHousing]
--where PropertyAddress is NULL
order by ParcelID

-- Checking to make sure there are not NULL values left for properyAddress. Need to create a selfjoin using parcelID and uniqueID to verify we update the correct field.
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..[NashvilleHousing] a
JOIN PortfolioProject..[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..[NashvilleHousing] a
JOIN PortfolioProject..[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID




-------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into individual Columns (address, City, State)

Select PropertyAddress
from PortfolioProject..[NashvilleHousing]


-- Charindex looks at the exact index where the lookup value is, we add -1 to it so we can remove the ',' from the output 
-- For the second Substring, we want to start withthe character after the ',' so we add +1 and end with Length of PropertyAddress
Select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

from PortfolioProject..[NashvilleHousing]



-- Adding the split fields as columns to the table
ALTER TABLE PortfolioProject..[Nashville Housing]
add ProperySplitAddress Nvarchar(255);

Update [NashvilleHousing]
SET ProperySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE PortfolioProject..[Nashville Housing]
add ProperySplitCity Nvarchar(255);

Update [NashvilleHousing]
SET ProperySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



SELECT *
From [NashvilleHousing]



--Here we will also split the OwnerAddress table but we will be using PARSENAME instead of substring
Select OwnerAddress
from NashvilleHousing


-- We look for OwnerAddress and to be able to use PARSENAME we replace the ',' with '.' 
Select PARSENAME(REPLACE(OwnerAddress,',','.'),3) as Address,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) as City,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) as State
FROM NashvilleHousing


-- Inserting into the database 
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)




ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(50)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)




ALTER TABLE NashvilleHousing
Add OwnerSplitState NvARCHAR(5)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)








-------------------------------------------------------------------------------------------------------------------------

-- Change 0 and 1 to Yes and No in "Sold as Vacant" field

Select DISTINCT(SoldAsVacant), COUNT(SoldasVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2


-- Using a Case statement and Casting as Varchar since the column type is Bit
Select SoldAsVacant 
, CASE When CAST(SoldAsVacant as VARCHAR) = '1' THEN 'Yes'
		When CAST(SoldAsVacant as VARCHAR) = '0' THEN 'No'
		Else CAST(SoldAsVacant as VARCHAR)
		END
From NashvilleHousing


-- Adding new Column and Updating 

--In case we want to drop the old SoldAsUpdated column with 0s and 1s
--Alter table NashvilleHousing
--drop column SoldAsUpdated

Alter Table NashvilleHousing
Add SoldAsVacantUpdated NVARCHAR(5)

Update NashvilleHousing
SET SoldAsVacantUpdated = CASE 
		When CAST(SoldAsVacant as VARCHAR) = '1' THEN 'Yes'
		When CAST(SoldAsVacant as VARCHAR) = '0' THEN 'No'
		Else CAST(SoldAsVacant as VARCHAR)
		END


-- Verifying count matches after update
Select Distinct(SoldAsVacantUpdated), COUNT(SoldAsVacantUpdated)
from NashvilleHousing
Group by SoldAsVacantUpdated






-------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates (Not standard practice, just for display purposes)

-- We will use multiple columns to partition by to get more accurate hits on potential duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) as row_num

From NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num >1
Order by PropertyAddress

--   Delete statement below has not been executed
--Delete 
--From RowNumCTE
--Where row_num >1





-------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns (Not standard practice, just for display purposes)


Select* 
from NashvilleHousing

Alter Table NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

Alter Table NashvilleHousing
DROP COLUMN SaleDate

Alter Table NashvilleHousing
DROP COLUMN SoldAsVacant