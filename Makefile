# Makefile for Academic Manuscript Citation Workflow
# Structured project with templates and automated initialization

# Project structure
SCRIPTS_DIR = scripts
OUTPUT_DIR = output
DOCS_DIR = docs

# Core files
MANUSCRIPT = manuscript.md
BIBLIOGRAPHY = reference.bib
MANUSCRIPT_TEMPLATE = manuscript.template.md
BIBLIOGRAPHY_TEMPLATE = reference.template.bib

# Scripts and styles
VALIDATION_SCRIPT = $(SCRIPTS_DIR)/validate_references.py
CSL_STYLE = $(SCRIPTS_DIR)/ama.csl

# Output files
HTML_OUTPUT = $(OUTPUT_DIR)/manuscript.html
DOCX_OUTPUT = $(OUTPUT_DIR)/manuscript.docx
LOG_FILE = $(OUTPUT_DIR)/log.txt

# Default target
.PHONY: all
all: check-files validate convert

# Initialize project by creating manuscript and reference files from templates
.PHONY: init
init:
	@echo "🚀 Initializing new manuscript project..."
	@if [ ! -f $(MANUSCRIPT) ]; then \
		echo "📝 Creating manuscript.md from template..."; \
		cp $(MANUSCRIPT_TEMPLATE) manuscript.md; \
	else \
		echo "ℹ️  manuscript.md already exists, skipping..."; \
	fi
	@if [ ! -f $(BIBLIOGRAPHY) ]; then \
		echo "📚 Creating reference.bib from template..."; \
		cp $(BIBLIOGRAPHY_TEMPLATE) $(BIBLIOGRAPHY); \
	else \
		echo "ℹ️  reference.bib already exists, skipping..."; \
	fi
	@echo "✅ Project initialized!"
	@echo ""
	@echo "Next steps:"
	@echo "1. Edit manuscript.md with your content"
	@echo "2. Add your references to reference.bib"
	@echo "3. Run 'make all' to generate outputs"

# Check that required files exist, offer to initialize if not
.PHONY: check-files
check-files:
	@if [ ! -f $(MANUSCRIPT) ] || [ ! -f $(BIBLIOGRAPHY) ]; then \
		echo "❌ Required files missing:"; \
		[ ! -f $(MANUSCRIPT) ] && echo "   - manuscript.md"; \
		[ ! -f $(BIBLIOGRAPHY) ] && echo "   - reference.bib"; \
		echo ""; \
		echo "Run 'make init' to create these files from templates."; \
		exit 1; \
	fi

# Ensure output directory exists
$(OUTPUT_DIR):
	@mkdir -p $(OUTPUT_DIR)

# Download AMA style if it doesn't exist
$(CSL_STYLE):
	@echo "📥 Downloading AMA citation style..."
	@mkdir -p $(SCRIPTS_DIR)
	curl -s -o $(CSL_STYLE) https://raw.githubusercontent.com/citation-style-language/styles/master/american-medical-association.csl
	@echo "✅ AMA style downloaded."

# Validate all DOIs and URLs in the bibliography
.PHONY: validate
validate: $(OUTPUT_DIR) $(LOG_FILE)

$(LOG_FILE): $(BIBLIOGRAPHY) $(VALIDATION_SCRIPT)
	@echo "🔍 Validating bibliography references..."
	@cd $(SCRIPTS_DIR) && uv run --with requests --with urllib3 python validate_references.py && mv log.txt ../$(LOG_FILE) 2>/dev/null || mv log.txt ../$(LOG_FILE)
	@echo "✅ Validation complete. Check $(LOG_FILE) for results."

# Convert manuscript to both HTML and DOCX formats
.PHONY: convert
convert: $(HTML_OUTPUT) $(DOCX_OUTPUT)

# Generate HTML output with citations
$(HTML_OUTPUT): $(MANUSCRIPT) $(BIBLIOGRAPHY) $(CSL_STYLE) | $(OUTPUT_DIR)
	@echo "📄 Converting to HTML with AMA style..."
	pandoc $(MANUSCRIPT) --bibliography=$(BIBLIOGRAPHY) --csl=$(CSL_STYLE) --citeproc -o $(HTML_OUTPUT)
	@echo "✅ HTML conversion complete: $(HTML_OUTPUT)"

# Generate DOCX output with citations
$(DOCX_OUTPUT): $(MANUSCRIPT) $(BIBLIOGRAPHY) $(CSL_STYLE) | $(OUTPUT_DIR)
	@echo "📄 Converting to DOCX with AMA style..."
	pandoc $(MANUSCRIPT) --bibliography=$(BIBLIOGRAPHY) --csl=$(CSL_STYLE) --citeproc -o $(DOCX_OUTPUT)
	@echo "✅ DOCX conversion complete: $(DOCX_OUTPUT)"

# Clean generated files
.PHONY: clean
clean:
	@echo "🧹 Cleaning generated files..."
	rm -rf $(OUTPUT_DIR)
	rm -rf .venv uv.lock
	@echo "✅ Clean complete."

# Clean all including downloaded files
.PHONY: clean-all
clean-all: clean
	@echo "🧹 Cleaning all generated and downloaded files..."
	rm -f $(CSL_STYLE)
	@echo "✅ Clean all complete."

# Reset project to template state
.PHONY: reset
reset: clean-all
	@echo "⚠️  Resetting project to template state..."
	@read -p "This will delete manuscript.md and reference.bib. Continue? [y/N] " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		rm -f manuscript.md $(BIBLIOGRAPHY); \
		echo "✅ Project reset to template state."; \
		echo "Run 'make init' to start over."; \
	else \
		echo "❌ Reset cancelled."; \
	fi

# Setup Python environment and dependencies
.PHONY: setup
setup:
	@echo "🔧 Setting up Python environment..."
	uv sync
	@echo "✅ Setup complete."

# Run full workflow from scratch
.PHONY: full
full: clean setup $(CSL_STYLE) check-files validate convert
	@echo ""
	@echo "🎉 Full workflow completed!"
	@echo "📁 Generated files:"
	@ls -la $(OUTPUT_DIR)/ 2>/dev/null || true

# Check that required tools are available
.PHONY: check-deps
check-deps:
	@echo "🔍 Checking dependencies..."
	@command -v pandoc >/dev/null 2>&1 || { echo "❌ pandoc is not installed. Install with: brew install pandoc"; exit 1; }
	@command -v uv >/dev/null 2>&1 || { echo "❌ uv is not installed. Install with: curl -LsSf https://astral.sh/uv/install.sh | sh"; exit 1; }
	@echo "✅ All dependencies found."

# Display project status
.PHONY: status
status:
	@echo "📊 Project Status"
	@echo "================="
	@echo "Structure:"
	@ls -la | grep '^d' || echo "  No directories"
	@echo ""
	@echo "Files:"
	@echo -n "  manuscript.md: "; [ -f manuscript.md ] && echo "✅ exists" || echo "❌ missing (run 'make init')"
	@echo -n "  reference.bib: "; [ -f reference.bib ] && echo "✅ exists" || echo "❌ missing (run 'make init')"
	@echo -n "  AMA style: "; [ -f $(CSL_STYLE) ] && echo "✅ exists" || echo "❌ missing (will download)"
	@echo ""
	@echo "Outputs:"
	@echo -n "  HTML: "; [ -f $(HTML_OUTPUT) ] && echo "✅ exists" || echo "❌ not generated"
	@echo -n "  DOCX: "; [ -f $(DOCX_OUTPUT) ] && echo "✅ exists" || echo "❌ not generated"
	@echo -n "  Log: "; [ -f $(LOG_FILE) ] && echo "✅ exists" || echo "❌ not generated"

# Display help
.PHONY: help
help:
	@echo "Academic Manuscript Citation Workflow"
	@echo "====================================="
	@echo ""
	@echo "🚀 Getting Started:"
	@echo "  init        - Initialize new project from templates"
	@echo "  status      - Show project status and missing files"
	@echo "  check-deps  - Check required tools are installed"
	@echo ""
	@echo "📝 Main Workflow:"
	@echo "  all         - Check files, validate references, and convert (default)"
	@echo "  validate    - Validate DOIs and URLs in bibliography"
	@echo "  convert     - Convert manuscript to HTML and DOCX with AMA style"
	@echo ""
	@echo "🔧 Maintenance:"
	@echo "  setup       - Setup Python environment and dependencies"
	@echo "  clean       - Remove generated output files"
	@echo "  clean-all   - Remove generated and downloaded files"
	@echo "  reset       - Reset project to template state (⚠️  destructive)"
	@echo "  full        - Complete workflow from clean state"
	@echo ""
	@echo "📁 Project Structure:"
	@echo "  Root files:  manuscript.md, reference.bib"
	@echo "  Templates:   $(MANUSCRIPT_TEMPLATE), $(BIBLIOGRAPHY_TEMPLATE)"
	@echo "  Scripts:     $(SCRIPTS_DIR)/"
	@echo "  Outputs:     $(OUTPUT_DIR)/"
	@echo "  Docs:        $(DOCS_DIR)/"

# Development targets
.PHONY: dev-validate
dev-validate:
	@echo "🔄 Running validation in development mode..."
	cd $(SCRIPTS_DIR) && python validate_references.py

.PHONY: dev-convert
dev-convert: $(CSL_STYLE) | $(OUTPUT_DIR)
	@echo "🔄 Running conversion in development mode..."
	pandoc $(MANUSCRIPT) --bibliography=$(BIBLIOGRAPHY) --csl=$(CSL_STYLE) --citeproc -t html5 -s -o $(HTML_OUTPUT)
	pandoc $(MANUSCRIPT) --bibliography=$(BIBLIOGRAPHY) --csl=$(CSL_STYLE) --citeproc -o $(DOCX_OUTPUT)

# Watch for changes (requires entr)
.PHONY: watch
watch:
	@echo "👀 Watching for changes... (requires 'entr' tool)"
	@command -v entr >/dev/null 2>&1 || { echo "❌ entr is not installed. Install with: brew install entr"; exit 1; }
	ls $(MANUSCRIPT) $(BIBLIOGRAPHY) | entr make convert

# Create example project - just uses init since template now has working examples
.PHONY: example
example:
	@echo "📖 The template now includes working examples!"
	@echo "Simply run 'make init' to get:"
	@echo "  • Breast cancer manuscript template with real citations"
	@echo "  • Bibliography with actual research references"
	@echo "  • Ready-to-use working example"
	@echo ""
	@echo "Then run 'make all' to generate outputs."