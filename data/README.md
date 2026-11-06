# Data

Cambodia's administrative boundaries: 25 provinces, 197 districts, 1633 communes.

| Table | Key | Parent key | Other columns |
|---|---|---|---|
| `province` | `province_pcode` (`KH12`) | | `province_name`, `area_km2` |
| `district` | `district_pcode` (`KH1201`) | `province_pcode` | `district_name`, `area_km2` |
| `commune` | `commune_pcode` (`KH120101`) | `district_pcode` | `commune_name`, `area_km2` |

- Codes nest: a district code starts with its province code; a commune code starts with its district code.
- Loaded into MySQL and MongoDB (database `cambodia` in both).
- Boundaries as of 4 October 2018; some may have changed.
- `area_km2` is rounded to 0.1 km², so child areas may not add up exactly.
- No population, prices, dates or coordinates.

## Files

`province.csv`, `district.csv`, `commune.csv`, and the original workbook `khm_admin_boundaries.xlsx`.

## Source

Cambodia – Subnational Administrative Boundaries, Department of Geography of Cambodia, via [OCHA HDX](https://data.humdata.org/dataset/cod-ab-khm). Licence: [CC BY-IGO](https://creativecommons.org/licenses/by/3.0/igo/legalcode). Downloaded 29 October 2026. CSVs keep the codes and English names; `area_sqkm` became `area_km2`, rounded to one decimal. Keep this attribution when sharing.
