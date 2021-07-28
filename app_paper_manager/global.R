info_tbl_path <- "./info.RDS"
if (!file.exists(info_tbl_path)) {
  info_tbl <- data.frame(
    paper_type = character(),
    paper_name = character(),
    paper_writer = character(),
    paper_year = integer(),
    paper_journal_name = character(),
    paper_data = character(),
    paper_method = character(),
    paper_summary = character(),
    paper_doi = character(),
    stringsAsFactors = FALSE
  )
  saveRDS(info_tbl, info_tbl_path)
}

info_tbl <- readRDS(info_tbl_path)