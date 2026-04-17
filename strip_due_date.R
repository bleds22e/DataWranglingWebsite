# Pre-render script: remove '### Due Date' headings and the date line that follows.
qmd_files <- list.files(pattern = "\\.qmd$", recursive = TRUE, full.names = TRUE)

for (filepath in qmd_files) {
  original <- readLines(filepath, warn = FALSE)
  due_date_lines <- which(trimws(original) == "### Due Date")

  if (length(due_date_lines) == 0) next

  # Build indices to remove: the heading, optional blank line, and date line
  to_remove <- c()
  for (i in due_date_lines) {
    to_remove <- c(to_remove, i)
    next_lines <- (i + 1):min(i + 2, length(original))
    for (j in next_lines) {
      to_remove <- c(to_remove, j)
      if (trimws(original[j]) != "") break  # stop after first non-blank line
    }
  }

  cleaned <- original[-to_remove]
  writeLines(cleaned, filepath)
  message("Stripped Due Date from ", filepath)
}
