
# Annual-File-Stats

A simple command line ruby program to count files and disk usage for NetApp folders. Annually, basic statistics for roughly a half dozen NetApp folders (and their subfolders) need to be tallied up.

File count, Total File Size (in bytes and MiBs)

To (hopefully) simplify this I've set the up to use a config file that can define the rules for each root directory (aka "parent" folder)

Example Output for `/netapp/pa`
```
FOLDER, FILE_COUNT, B, M
ChristmasCarol,4,1796868172,1713.63
DIL,117408,2187977645887,2086618.09
VTM,16,1274688516,1215.64
aerial,3600,535386879876,510584.72
```
---
### Notes & Terminology

```
Root Dir
  -> Top Level Dir
    -> Sub Dir 1
    -> Sub Dir 2
    -> Sub Dir 3
```
---

### Setup

A "profile" must be setup in `config/profiles.yml`

Example profile:
```yaml
da:
  name: da
  root: /netapp/da
  rules:
    - target: top_level_folder
      type: exclude
      filter:
        - cas
        - UConly
        - UCBonly
    - target: sub_folders
      type: exclude
      filter:
        - ead
        - logs
        - mets
        - sgm
```

**To Run:**
`ruby annual_stats.rb -r da`

---

### Future
Include relationship (the rollup for which library each folder belongs to [e.g., banc, eal, etc...])

banc -> /netapp/da/ironman -> pdfs 2500 -> tifs 13000

It may be beneficial to have a breakdown of file types, example:
```
/netapp/da/pa/
              top-level-dir-1
                pdf ->  12,305 |    13989B |  139MiB
                tif -> 139,100 | 99332993B | 9923MiB
```











