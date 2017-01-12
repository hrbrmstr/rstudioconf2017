# SATCAT Sources Table --------------------------------------------------------------

satcat_src_URL <- "https://celestrak.com/satcat/sources.asp"
satcat_src_fil <- file.path("./data", basename(satcat_src_URL))
satcat_src_csv_path <- file.path("./data", paste0(file_path_sans_ext(basename(satcat_src_URL)), ".csv"))
satcat_src_rds_path <- file.path("./data", paste0(file_path_sans_ext(basename(satcat_src_URL)), ".rds"))

if (!file.exists(satcat_src_fil)) {

  download.file(satcat_src_URL, satcat_src_fil)

  read_html(satcat_src_fil) %>%
    html_nodes("table[cellpadding='3']") %>%
    html_table(header=TRUE) %>%
    .[[1]] %>%
    set_names(c("source", "source_full_name")) %>%
    mutate(source_full_name=stri_replace_all_regex(source_full_name, "[[:space:]]+", " ")) %>%
    tbl_df() -> satcat_src

  write_csv(satcat_src, satcat_src_csv_path)
  saveRDS(satcat_src, satcat_src_rds_path)

} else {
  satcat_src <- readRDS(satcat_src_rds_path)
}

# SATCAT Launch Sites ---------------------------------------------------------------

satcat_sites_URL <- "https://celestrak.com/satcat/launchsites.asp"
satcat_sites_fil <- file.path("./data", basename(satcat_sites_URL))
satcat_sites_csv_path <- file.path("./data", paste0(file_path_sans_ext(basename(satcat_sites_URL)), ".csv"))
satcat_sites_rds_path <- file.path("./data", paste0(file_path_sans_ext(basename(satcat_sites_URL)), ".rds"))

if (!file.exists(satcat_sites_fil)) {

  download.file(satcat_sites_URL, satcat_sites_fil)

  read_html(satcat_sites_fil) %>%
    html_nodes("table[cellpadding='3']") %>%
    html_table(header=TRUE) %>%
    .[[1]] %>%
    set_names(c("launch_site", "launch_site_full_name")) %>%
    mutate(launch_site_full_name=stri_replace_all_regex(launch_site_full_name, "[[:space:]]+", " ")) %>%
    tbl_df() -> satcat_sites

  write_csv(satcat_sites, satcat_sites_csv_path)
  saveRDS(satcat_sites, satcat_sites_rds_path)

} else {
  satcat_sites <- readRDS(satcat_sites_rds_path)
}

# SATCAT Operational Status ---------------------------------------------------------

satcat_opstat_URL <- "https://celestrak.com/satcat/status.asp"
satcat_opstat_fil <- file.path("./data", basename(satcat_opstat_URL))
satcat_opstat_csv_path <- file.path("./data", paste0(file_path_sans_ext(basename(satcat_opstat_URL)), ".csv"))
satcat_opstat_rds_path <- file.path("./data", paste0(file_path_sans_ext(basename(satcat_opstat_URL)), ".rds"))

if (!file.exists(satcat_opstat_fil)) {

  download.file(satcat_opstat_URL, satcat_opstat_fil)

  read_html(satcat_opstat_fil) %>%
    html_nodes("table[cellpadding='3']") %>%
    html_table(header=TRUE) %>%
    .[[1]] %>%
    set_names(c("op_status_code", "op_status_descr")) %>%
    mutate(op_status_descr=stri_replace_all_regex(op_status_descr, "[[:space:]]+", " ")) %>%
    tbl_df() -> satcat_opstat

  write_csv(satcat_opstat, satcat_opstat_csv_path)
  saveRDS(satcat_opstat, satcat_opstat_rds_path)

} else {
  satcat_opstat <- readRDS(satcat_opstat_rds_path)
}

# SATCAT Annex file -----------------------------------------------------------------

satcat_annex_URL <- "https://celestrak.com/pub/satcat-annex.txt"
satcat_annex_fil <- file.path("./data", basename(satcat_annex_URL))
satcat_annex_csv_path <- file.path("./data", paste0(file_path_sans_ext(basename(satcat_annex_URL)), ".csv"))
satcat_annex_rds_path <- file.path("./data", paste0(file_path_sans_ext(basename(satcat_annex_URL)), ".rds"))

if (!file.exists(satcat_annex_fil)) {

  download.file(satcat_annex_URL, satcat_annex_fil)

  read_lines(satcat_annex_fil) %>%
    stri_split_fixed("|", 2) %>%
    map_df(~data_frame(norad_cat_num=.[1],
                       name=flatten_chr(stri_split_fixed(.[2], "|")))) -> satcat_annex

  write_csv(satcat_annex, satcat_annex_csv_path)
  saveRDS(satcat_annex, satcat_annex_rds_path)

} else {
  satcat_annex <- readRDS(satcat_annex_rds_path)
}

# Main SATCAT data file -------------------------------------------------------------

satcat_URL <- "https://celestrak.com/pub/satcat.txt"
satcat_fil <- file.path("./data", basename(satcat_URL))
satcat_csv_path <- file.path("./data", paste0(file_path_sans_ext(basename(satcat_URL)), ".csv"))
satcat_rds_path <- file.path("./data", paste0(file_path_sans_ext(basename(satcat_URL)), ".rds"))

if (!file.exists(satcat_fil)) {

  download.file(satcat_URL, satcat_fil)

  satcat_col_names <- c("designator", "norad_cat_num", "multiple", "payload", "op_status_code",
                        "satellite_name", "source", "launch_date" , "launch_site", "decay_date",
                        "orbital_period", "inclination", "apogee", "perigee", "radar_cross_section",
                        "orbital_status_code")

  satcat_cols <- cols(designator = "c", norad_cat_num = "c", multiple = "c", payload = "c",
                      op_status_code = "c", satellite_name = "c", source = "c", launch_date = "D",
                      launch_site = "c", decay_date = "D", orbital_period = "d", inclination = "d",
                      apogee = "d", perigee = "d", radar_cross_section = "d", orbital_status_code = "c")

  satcat_cols_start <- c(1, 14, 20, 21, 22, 24, 50, 57, 69, 76, 88, 97, 104, 112, 120, 130)
  satcat_cols_end <- c(11, 18, 20, 21, 22, 47, 54, 66, 73, 85, 94, 101, 109, 117, 127, 132)

  read_fwf(satcat_fil, na=c("N/A"), col_types=satcat_cols,
           fwf_positions(satcat_cols_start, satcat_cols_end, satcat_col_names)) %>%
    mutate(multiple=(multiple=="M"), payload=(payload=="*")) %>%
    left_join(satcat_src, by="source") %>%
    left_join(satcat_sites, by="launch_site") %>%
    left_join(satcat_opstat, by="op_status_code") %>%
    mutate(is_active=(op_status_code %in% c("+", "P", "B", "S", "X"))) -> satcat

  write_csv(satcat, satcat_csv_path)
  saveRDS(satcat, satcat_rds_path)

} else {
  satcat <- readRDS(satcat_rds_path)
}
