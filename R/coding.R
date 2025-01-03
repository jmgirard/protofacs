# coding -----------------------------------------------------------------------
new_coding <- function(x = character()) {
  stopifnot(is.character(x))
  out <- structure(x, class = "facs_coding")
  out
}

validate_coding <- function(x) {
  # Extract attributes
  scheme <- attr(x, "scheme")
  # Remove all whitespace characters
  x <- gsub("\\s+", "", x)
  # Capitalize all letters
  x <- toupper(x)
  # Check for unallowed characters
  ccx <- check_coding(x)
  if (!all(ccx)) {
    cli::cli_abort(
      paste0(
        "The following elements of `x` are not valid FACS codes: ", 
        paste(paste0('(', which(!ccx), ') "', x[!ccx], '"'), collapse = ", ")
      )
    )
  }
  # Split on plus signs
  x <- strsplit(x, split = "+", fixed = TRUE)
  # Sort by numeric components
  x <- lapply(x, sort_by_numeric)
  # Recombine into string
  x <- lapply(x, function(z) paste(z, collapse = "+"))
  x <- unlist(x)
  # Return
  new_coding(x)
}

#' @export
coding <- function(x) {
  validate_coding(x)
}

#' @export
check_coding <- function(x) {
  pattern <- paste0(
    "^(?:[", 
    paste(facs_prefixes, collapse = ""), 
    "]?\\d{1,2}[", 
    paste(facs_suffixes, collapse = ""),
    "]?)(?:\\+[", 
    paste(facs_prefixes, collapse = ""),
    "]?\\d{1,2}[", 
    paste(facs_suffixes, collapse = ""),
    "]?)*$"
  )
  grepl(pattern, x)
}

#' @method print facs_coding
#' @export
print.facs_coding <- function(x, ...) {
  print.default(unclass(x))
  cat("FACS Coding\n")
}
