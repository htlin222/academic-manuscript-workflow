# Academic Manuscript Citation Workflow

A professional, template-based workflow for automatically adding citations to academic manuscripts and generating properly formatted outputs using Pandoc with AMA citation style.

## 🚀 Quick Start

```bash
# Initialize a new project
make init

# Edit your manuscript and references
# manuscript.md - your content
# reference.bib - your bibliography

# Generate outputs
make all
```

## 📁 Project Structure

```
academic-manuscript-workflow/
├── 📄 manuscript.md              # Working manuscript (created from template)
├── 📚 reference.bib              # Bibliography (created from template)
├── 📋 CLAUDE.md                  # Claude Code LLM instructions
├── 📋 Makefile                   # Automation workflow
├── 📖 README.md                  # This file
├── 🚫 .gitignore                 # Git ignore patterns
├── ⚙️  pyproject.toml             # Python project configuration
│
├── 📂 scripts/                   # Utility scripts
│   ├── 🔍 validate_references.py # DOI/URL validation script
│   └── 📝 ama.csl                # AMA citation style (auto-downloaded)
│
├── 📂 output/                    # Generated files (ignored by git)
│   ├── 🌐 manuscript.html        # HTML output with citations
│   ├── 📄 manuscript.docx        # Word document output
│   └── 📊 log.txt                # Validation results
│
└── 📄 Templates (for new projects):
    ├── manuscript.template.md     # Manuscript template
    └── reference.template.bib     # Bibliography template
```

## 🛠️ Prerequisites

**Required Tools:**

- [Pandoc](https://pandoc.org/) - Document conversion
- [uv](https://github.com/astral-sh/uv) - Fast Python package manager
- Python 3.9+

**Installation:**

```bash
# macOS
brew install pandoc

# Install uv (cross-platform)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verify installation
make check-deps
```

## 📋 Available Commands

### 🚀 Getting Started

```bash
make init         # Initialize new project from templates
make status       # Show project status and missing files
make check-deps   # Check required tools are installed
make help         # Show all available commands
```

### 📝 Main Workflow

```bash
make all          # Check files, validate, and convert (default)
make validate     # Validate DOIs and URLs in bibliography
make convert      # Convert to HTML and DOCX with AMA citations
```

### 🔧 Maintenance

```bash
make setup        # Setup Python environment
make clean        # Remove output files
make clean-all    # Remove outputs and downloaded files
make reset        # Reset to template state (⚠️ destructive)
make full         # Complete workflow from clean state
```

### 🔬 Development

```bash
make example      # Create example project with sample content
make watch        # Auto-rebuild on file changes (requires entr)
make dev-validate # Run validation without uv
make dev-convert  # Run conversion in development mode
```

## 📖 Usage Guide

### 1. Initialize New Project

```bash
make init
```

This creates `manuscript.md` and `reference.bib` from templates.

### 2. Edit Your Content

**manuscript.md** - Write your manuscript with citations:

```markdown
# Your Title

Breast cancer affects millions worldwide [@Smith2024].
Recent studies show improved outcomes [@Jones2023; @Brown2022].
```

**reference.bib** - Add your references:

```bibtex
@article{Smith2024,
  title={Recent Advances in Cancer Treatment},
  author={Smith, Jane and Doe, John},
  journal={Journal of Oncology},
  year={2024},
  doi={10.1000/example}
}
```

### 3. Generate Outputs

```bash
make all
```

Creates HTML and DOCX files in the `output/` directory with:

- ✅ Numbered AMA-style citations
- ✅ Complete bibliography
- ✅ Validated DOIs and URLs

## 🎯 Key Features

### 📚 Citation Management

- **AMA Style**: Numbered superscripts with Vancouver bibliography
- **Multiple Formats**: Support for journal articles, books, conferences, web resources
- **DOI Validation**: Automatic checking of DOI resolution
- **URL Verification**: Validates accessibility of all URLs

### 📄 Output Formats

- **HTML**: Web-ready with linked citations and references
- **DOCX**: Microsoft Word compatible for collaboration and editing
- **Professional Formatting**: Clean, publication-ready appearance

### 🔄 Automated Workflow

- **Template System**: Start new projects instantly
- **Dependency Management**: Automatic Python environment setup
- **File Validation**: Ensures all required files exist
- **Error Handling**: Clear messages and recovery suggestions

### 🛡️ Quality Assurance

- **Reference Validation**: Checks DOI resolution and URL accessibility
- **Comprehensive Logging**: Detailed validation results with timestamps
- **Git Integration**: Proper .gitignore excludes generated files

## 📝 Citation Examples

### In-Text Citations

```markdown
Single citation: Recent studies show progress [@Smith2024].
Multiple: Several studies confirm this [@Smith2024; @Jones2023].
Inline: Smith et al. [@Smith2024] demonstrated significant improvements.
```

### Bibliography Formats Supported

- Journal articles with DOI
- Books and edited volumes
- Conference proceedings
- Government reports
- Web resources and databases
- Preprints (bioRxiv, arXiv)
- Clinical trial registrations

### Example Output (AMA Style)

**In-text**: Recent advances in treatment¹ show promising results²,³.

**Bibliography**:

1. Smith J, Doe J. Recent advances in cancer treatment. _J Oncol_. 2024;15(3):123-145.
2. Jones A, Brown B. Clinical outcomes in modern therapy. _Cancer Res_. 2023;45(2):67-89.

## 🔧 Customization

### Different Citation Styles

```bash
# Download a different CSL style
curl -o scripts/nature.csl https://raw.githubusercontent.com/citation-style-language/styles/master/nature.csl

# Update Makefile CSL_STYLE variable
# Then run: make convert
```

### Project Templates

Modify `manuscript.template.md` and `reference.template.bib` to customize templates for new projects.

### Validation Rules

Extend `scripts/validate_references.py` to add custom validation rules:

- Journal name validation
- Author ORCID verification
- Retraction checking
- Impact factor inclusion

## 🚨 Troubleshooting

### Common Issues

| Issue                      | Solution                          |
| -------------------------- | --------------------------------- |
| Missing dependencies       | `make check-deps`                 |
| Files not found            | `make status` then `make init`    |
| 403 validation errors      | Normal - publisher bot protection |
| Python environment issues  | `make setup`                      |
| Pandoc conversion failures | Check manuscript syntax           |

### File Status Check

```bash
make status
```

Shows project structure and file availability.

### Validation Results

Check `output/log.txt` for detailed validation results. 403 errors are common due to publisher anti-bot measures but don't indicate invalid references.

## 🌟 Examples

### Academic Paper Template

```bash
make init
# Creates structured academic paper template with:
# - Abstract, Introduction, Methods, Results, Discussion
# - Proper citation placeholders
# - Example bibliography entries
```

### Sample Project

```bash
make example
# Creates working example with:
# - Breast cancer treatment manuscript
# - 13 real academic references
# - Demonstrates all features
```

## 🤝 Contributing

1. **Fork** the repository
2. **Create** feature branch: `git checkout -b feature/new-style`
3. **Add** new citation styles or validation features
4. **Test** with `make full`
5. **Submit** pull request

### Extending the Workflow

- Add new output formats (PDF, LaTeX)
- Integrate with reference managers (Zotero, Mendeley)
- Add journal-specific citation styles
- Implement automated reference searching

## 📄 License

This project is designed for educational and research purposes. Please ensure compliance with publisher terms of service when using automated reference validation.

## 🙏 Acknowledgments

- **Pandoc** - Universal document converter
- **Citation Style Language** - Open citation style repository
- **uv** - Modern Python package management
- **AMA Manual of Style** - Citation format specification

---

**Generated with Claude Code** - A professional academic writing workflow with automated citation management.

## 📊 Project Status

- ✅ Template-based initialization
- ✅ AMA citation style implementation
- ✅ Multi-format output generation
- ✅ Reference validation system
- ✅ Structured project organization
- ✅ Comprehensive documentation
- ✅ Git integration and workflow automation
