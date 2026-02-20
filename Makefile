PROJECT_NAME = ITCV
CV_FILE = cv.typ
PDF_OUT = output.pdf

.DEFAULT: help

.PHONY: all clean watch

help:
	@echo ""
	@echo "$(BOLD)$(PROJECT_NAME)$(RESET)"
	@echo "===="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-8s\033[0m %s\n", $$1, $$2}'
	@echo ""

all:  ## compile to PDF
	typst compile $(CV_FILE) $(PDF_OUT)

watch: ## watch and recompile
	typst watch $(CV_FILE) $(PDF_OUT)

clean:  ## clean build artifacts
	rm -f $(PDF_OUT)
