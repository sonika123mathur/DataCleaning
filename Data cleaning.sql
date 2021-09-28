/* Cleaning Data  */

Select * FROM PortfolioProject.dbo.[National Housing]


/* Standardize the Date Format */


Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.[National Housing]


Update [National Housing]
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE [National Housing]
Add SaleDateConverted Date;

Update [National Housing]
SET SaleDate = CONVERT(Date,SaleDate)


-- Populate Property Address Data
Select *
From PortfolioProject.dbo.[National Housing]
--Where PropertyAddress is Null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[National Housing] a
JOIN PortfolioProject.dbo.[National Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[National Housing] a
JOIN PortfolioProject.dbo.[National Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress From PortfolioProject.dbo.[National Housing]

SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address 
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address 
From PortfolioProject.dbo.[National Housing]

ALTER TABLE [National Housing]
Add PropertySplitAddress NVARCHAR(255);

Update [National Housing]
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE [National Housing]
Add PropertySplitCity NVARCHAR(255);

Update [National Housing]
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select * 
From PortfolioProject.dbo.[National Housing]

Select OwnerAddress
From PortfolioProject.dbo.[National Housing]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.[National Housing]

ALTER TABLE PortfolioProject..[National Housing]
ADD OwnerSplitAddress Nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE PortfolioProject..[National Housing]
ADD OwnerSplitCity Nvarchar(255);

UPDATE PortfolioProject..[National Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE PortfolioProject..[National Housing]
ADD OwnerSplitState Nvarchar(255);

UPDATE PortfolioProject..[National Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT *
FROM PortfolioProject..[National Housing]


-- Changing 'Y' and 'N' to 'Yes' and 'No' respectively

SELECT SoldAsVacant
FROM PortfolioProject..[National Housing]

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject..[National Housing]

UPDATE PortfolioProject..[National Housing]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

SELECT SoldAsVacant
FROM PortfolioProject..[National Housing]

-- Removing duplicates

SELECT *
FROM PortfolioProject..[National Housing]

WITH DuplicateCTE AS (
SELECT *, ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 LegalReference,
				 SaleDate,
				 SalePrice
				 ORDER BY UniqueID
				 ) as row_num
FROM PortfolioProject..[National Housing]
)
DELETE
FROM DuplicateCTE
WHERE row_num > 1



-- Deleting Unused Columns

SELECT *
FROM PortfolioProject..[National Housing]

ALTER TABLE PortfolioProject..[National Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..[National Housing]
DROP COLUMN SaleDate