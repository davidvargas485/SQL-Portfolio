# In this SQL, I execute multiple queries that allow me to clean various aspects of the dataset.

# Tools used: BigQuery

#1. Let's standardize the date format.

UPDATE projects.nashville_housing 
SET SaleDate = FORMAT_DATE('%m/%d/%y', SaleDate);

#2. Let's populate property address data where NULL by linking parcel ID's to addresses.

SELECT 
  n1.ParcelID,
  IFNULL(n1.PropertyAddress, n2.PropertyAddress) AS property_address
FROM
  projects.nashville_housing as n1
JOIN
  projects.nashville_housing AS n2
ON
  n1.ParcelID = n2.ParcelID AND
  n1.UniqueID_ <> n2.UniqueID_
WHERE
  n1.PropertyAddress IS NULL;

UPDATE n1 
SET PropertyAddress = IFNULL(n1.PropertyAddress, n2.PropertyAddress)
FROM projects.nashville_housing as n1
JOIN projects.nashville_housing AS n2
ON 
  n1.ParcelID = n2.ParcelID AND n1.UniqueID_ <> n2.UniqueID_
WHERE n1.PropertyAddress IS NULL; 

#3. Let's split up addresses to three columns (address, city, state).

SELECT
  SPLIT(PropertyAddress, ',')[OFFSET(0)] AS property_address,
  SPLIT(PropertyAddress, ',')[OFFSET(1)] AS city,
  SPLIT(OwnerAddress, ',')[OFFSET(2)] AS state,
FROM
  projects.nashville_housing;

ALTER TABLE projects.nashville_housing
ADD COLUMN property_address STRING;
UPDATE projects.nashville_housing
SET property_address = SPLIT(PropertyAddress, ',')[OFFSET(0)];

ALTER TABLE projects.nashville_housing
ADD COLUMN city STRING;
UPDATE projects.nashville_housing
SET city = SPLIT(PropertyAddress, ',')[OFFSET(1)];

ALTER TABLE projects.nashville_housing
ADD COLUMN state STRING;
UPDATE projects.nashville_housing
SET state = SPLIT(OwnerAddress, ',')[OFFSET(2)];

#4. Let's change Y and N to Yes and No in column "SoldAsVacant."

SELECT 
  CASE 
    WHEN SoldAsVacant = "Y" THEN "Yes"
    WHEN SoldAsVacant = "N" THEN "No"
    ELSE SoldAsVacant
  END
FROM
  projects.nashville_housing;

UPDATE projects.nashville_housing
SET SoldAsVacant = CASE 
  WHEN SoldAsVacant = "Y" THEN "Yes"
  WHEN SoldAsVacant = "N" THEN "No"
  ELSE SoldAsVacant
  END;

SELECT
  DISTINCT SoldAsVacant,
  COUNT(SoldAsVacant) AS count
FROM
  projects.nashville_housing
GROUP BY
  SoldAsVacant;

#5. Let's identify duplicates.

WITH DupCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY 
    ParcelID,
		PropertyAddress,
		SalePrice,
    SaleDate,
    LegalReference
  ORDER BY
    UniqueID_
	) AS row_type
FROM
  projects.nashville_housing
)
Select *
FROM DupCTE
WHERE row_type > 1;

#6. Let's delete columns that will not be used. 

ALTER TABLE projects.nashville_housing
DROP COLUMN OwnerAddress;

ALTER TABLE projects.nashville_housing
DROP COLUMN PropertyAddress;

ALTER TABLE projects.nashville_housing
DROP COLUMN TaxDistrict;

ALTER TABLE projects.nashville_housing
DROP COLUMN PropertyAddress;

ALTER TABLE projects.nashville_housing
DROP COLUMN SaleDate;
