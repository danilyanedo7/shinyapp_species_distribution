# shinyapp_species_distribution

Hi guys, this is my first project for Shiny app related, it's basically a set of Shiny apps designed to help biologists with biodiversity monitoring and species distribution mapping. The apps allow you to analyze biodiversity data and easily create interactive maps to visualize species distributions using Leaflet. While these tools are still a work in progress and could use some improvements, they provide a simple way for researchers to explore and understand their data. I hope these apps help make your biodiversity research a bit more accessible and engaging as I continue to refine them.

## Dataset Format

The dataset should be in a tabular format with the following columns:

| Column Name | Description |
|----|----|
| `Species` | Name of the species |
| `Site` | Location where the observation was made |
| `Observation` | Observation ID or number |
| `Abundance` | Number of individuals observed |
| `lat` | Latitude of the observation site |
| `lon` | Longitude of the observation site |
| `Conservation_Status` | Conservation status of the species |
| `Habitat_Type` | Type of habitat where the species was observed |
| `Endangered_Indicator` | Indicator if the species is endangered (1 for yes, 0 for no) |

### Example Dataset

| Species | Site | Observation | Abundance | lat | lon | Conservation_Status | Habitat_Type | Endangered_Indicator |
|----|----|----|----|----|----|----|----|----|
| Javan Rhino | Ujung Kulon National Park | 1 | 5 | -6.784248449 | 105.370916623 | Critically Endangered | Tropical Rainforest | 1 |
| Javan Rhino | Ujung Kulon National Park | 2 | 6 | -6.774233897 | 105.378844001 | Critically Endangered | Tropical Rainforest | 1 |

Ensure that the dataset is in a CSV or TSV format with these column headers and values. Also ensure that you fill all the cells so the NA value is not introduced. For example, if you dont have any information about Conservation_Status, just add "-". Don't left it empty.

To use the app, run this code chunk in your Rstudio:

```{r}
shiny::runGitHub('shinyapp_species_distribution', 'danilyanedo7')
```
