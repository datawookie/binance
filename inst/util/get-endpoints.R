library(rvest)
library(stringr)

html <- read_html("https://binance-docs.github.io/apidocs/spot/en/")

tags <- html %>%
  html_elements("blockquote + pre + p > code")

for (tag in tags) {
  tag <- tag %>% html_text() %>% str_squish()

  if (grepl("^(GET|POST|DELETE)", tag)) {
    cat(paste("- [ ] `", tag, "`\n", sep = ""))
  }
}
