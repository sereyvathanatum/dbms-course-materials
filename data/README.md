# Data

The course uses Cambodia's administrative boundaries: 25 provinces (including Phnom Penh), 197 districts and 1633 communes. Each one has a code (P-code), an English name and an area.

| Table | Primary key | Foreign key | Other columns |
|---|---|---|---|
| `province` | `province_pcode` (e.g. `KH12`) | | `province_name`, `area_km2` |
| `district` | `district_pcode` (e.g. `KH1201`) | `province_pcode` | `district_name`, `area_km2` |
| `commune` | `commune_pcode` (e.g. `KH120101`) | `district_pcode` | `commune_name`, `area_km2` |

The codes are nested: the first four characters of a district code are its province code, and the first six characters of a commune code are its district code.

The same rows are loaded into MySQL (database `cambodia`) and MongoDB (database `cambodia`, one document per row). In MongoDB, `area_km2` is a number and the codes are strings.

## Things to know

- The boundaries are valid as of 4 October 2018 (reviewed by HDX in October 2024). Some may have changed since.
- `area_km2` is the area in square kilometres, rounded to one decimal place. Because of rounding, the district areas of a province may not add up exactly to the province area.
- Names use the publisher's English spelling.
- There is no population, price, date or location (coordinate) data.

## Files

- `province.csv`, `district.csv`, `commune.csv`: the three tables
- `khm_admin_boundaries.xlsx`: the original workbook downloaded from HDX

## Source and licence

Cambodia – Subnational Administrative Boundaries (COD-AB), Department of Geography of Cambodia, published by OCHA on the [Humanitarian Data Exchange](https://data.humdata.org/dataset/cod-ab-khm). Licence: [Creative Commons Attribution for Intergovernmental Organisations (CC BY-IGO)](https://creativecommons.org/licenses/by/3.0/igo/legalcode). Downloaded on 29 October 2026.

The CSV files were made from the workbook: the `adm1`, `adm2` and `adm3` codes and English names were kept, and `area_sqkm` was renamed `area_km2` and rounded to one decimal place. Please keep this attribution if you share the data.
