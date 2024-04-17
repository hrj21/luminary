# load package
# library(luminary)

# load example dataset
data(u5plex)

# display object
u5plex

# extract elements
get_well_data(u5plex)    |> View()
get_summary_data(u5plex) |> View()
get_analytes(u5plex)     |> View()
get_metadata(u5plex)     |> View()
get_curve_data(u5plex)   |> View()

# plot curves
plot_curves(u5plex)
plot_curves(u5plex, facet_scales = "free")
plot_curves(
    u5plex, 
    interactive = TRUE, 
    rug = FALSE, 
    analytes = c("AFM", "EPCR")
)

# refit curves
refit_u5plex <- refit_curves(u5plex)
