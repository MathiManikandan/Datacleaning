select * from First_project

-----1.standardize date formate
select * from First_project

alter table First_project add salesdateconverted date


update First_project set salesdateconverted=cast (saledate as date)

-------update the null column

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull (a.PropertyAddress,b.PropertyAddress)
from First_project a 
join First_project b 
on a.ParcelID=b.ParcelID 
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

begin tran

update a 
set PropertyAddress=isnull (a.PropertyAddress,b.PropertyAddress)
from First_project a 
join First_project b 
on a.ParcelID=b.ParcelID 
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

rollback



-------breaking out address into induvidual column (address,city,state)

select * from First_project
--propertyaddress change
select *,parsename(replace(propertyaddress,',','.'),1),
parsename(replace(propertyaddress,',','.'),2)
from First_project

alter table First_project add propertysplitaddres nvarchar(255)


update First_project set propertysplitaddres=parsename(replace(propertyaddress,',','.'),2)


alter table First_project add propertysplitcity nvarchar(255)

update First_project set propertysplitcity=parsename(replace(propertyaddress,',','.'),1)
--owneraddress change
select *,
parsename(replace(owneraddress,',','.'),3) oaddress,
parsename(replace(owneraddress,',','.'),2)as city,
parsename(replace(owneraddress,',','.'),1)as ostate
from First_project


alter table First_project add Ownersplitaddres nvarchar(255)
update First_project set Ownersplitaddres=parsename(replace(owneraddress,',','.'),3) 

alter table First_project add Ownersplitcity nvarchar(255)
update First_project set Ownersplitcity=parsename(replace(owneraddress,',','.'),2)

alter table First_project add Ownersplitstate nvarchar(255)
update First_project set Ownersplitstate=parsename(replace(owneraddress,',','.'),1)



------change sold as vacant
select distinct(SoldAsVacant) from First_project

select * ,case
when soldasvacant='y' then 'Yes'
when soldasvacant='n' then 'No'
else soldasvacant
end
from First_project


update First_project set SoldAsVacant=case
when soldasvacant='y' then 'Yes'
when soldasvacant='n' then 'No'
else soldasvacant
end
from First_project

select distinct(SoldAsVacant) from First_project


----------------remove duplicates
with dup
as
(
select *, ROW_NUMBER() over (partition by parcelid,legalreference,saledate,propertyaddress order by uniqueid)rn from First_project
)
delete from dup where  rn>1

---------delete unused column


select * from First_project

alter table first_project drop column propertyaddress,saledate,owneraddress


--------------------standize the date 



select *,cast (SaleDate as date) from cleaning
alter table cleaning add converedsalesdate date

update cleaning set converedsalesdate=cast (SaleDate as date)

--------populated property address

select * from cleaning


select a.ParcelID,a.PropertyAddress,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress) from cleaning a
join cleaning b on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from cleaning a
join cleaning b on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


-------------braking out address into individual column (address,city,state)

select parsename(replace(propertyaddress,',','.'),2)adress,
parsename(replace(propertyaddress,',','.'),1) city
from cleaning

alter table cleaning add splitpropertyaddress nvarchar(255)

update cleaning set splitpropertyaddress =parsename(replace(propertyaddress,',','.'),2)



alter table cleaning add splitpropertycity nvarchar(255)
update cleaning set splitpropertycity =parsename(replace(propertyaddress,',','.'),1)

select * from cleaning

select parsename(replace(OwnerAddress,',','.'),3)adress,
parsename(replace(OwnerAddress,',','.'),2) city,
parsename(replace(OwnerAddress,',','.'),1) ostate
from cleaning

alter table cleaning add split_owner_address nvarchar(255)
update cleaning set split_owner_address =parsename(replace(OwnerAddress,',','.'),3)


alter table cleaning add split_owner_city nvarchar(255)
update cleaning set split_owner_city =parsename(replace(OwnerAddress,',','.'),2)


alter table cleaning add split_owner_state nvarchar(255)
update cleaning set split_owner_state =parsename(replace(OwnerAddress,',','.'),1)



---------------change soldasvacant


select distinct(SoldAsVacant) from cleaning

select case
when SoldAsVacant='y' then 'Yes'
when SoldAsVacant='n' then 'No'
else SoldAsVacant
end
from cleaning

update cleaning set SoldAsVacant=case
when SoldAsVacant='y' then 'Yes'
when SoldAsVacant='n' then 'No'
else SoldAsVacant
end
from cleaning

--------------------remove duplicate



---find duplicate
with dup
as
(
select *, ROW_NUMBER() over ( partition by parcelid,propertyaddress,saledate,legalreference order by uniqueid)rn   from cleaning
)
select * from dup where rn>1


---remove duplicate
with dup
as
(
select *, ROW_NUMBER() over ( partition by parcelid,propertyaddress,saledate,legalreference order by uniqueid)rn   from cleaning
)
delete from dup where rn>1



-----------remove unused coulumn

select * from cleaning

alter table cleaning drop column propertyaddress,saledate,owneraddress




----------------covid 


select * from [dbo].[CovidDeaths]



