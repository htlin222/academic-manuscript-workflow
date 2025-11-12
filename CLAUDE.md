# Academic Manuscript Citation Workflow - Claude Code Instructions

**For Claude Code LLM**: This project automates academic manuscript writing with proper citations, reference validation, and multi-format output generation.

## 🚀 Quick Start for Claude Code Users

When a user asks for help with academic writing, citations, or manuscript preparation:

1. **Initialize the project**:

   ```bash
   make init
   ```

   This creates working files with a breast cancer research example.

2. **Web search for references** when user needs citations:
   - Use WebSearch to find recent academic papers on the user's topic
   - Focus on high-impact journals, recent publications (2020+)
   - Search for DOI numbers and official URLs
   - Prioritize systematic reviews, clinical trials, meta-analyses

3. **Add citations to manuscript**:
   - Edit `manuscript.md` with user's content
   - Add citations using format: `[@AuthorYear]`
   - Ensure citation keys match entries in `reference.bib`

4. **Update bibliography**:
   - Add new references to `reference.bib` following BibTeX format
   - Include DOI and URL when available
   - Use consistent naming: `FirstAuthorLastNameYear`

5. **Generate outputs**:
   ```bash
   make all
   ```
   This validates references and creates HTML/DOCX with AMA citations.

## 📖 Detailed Workflow Instructions

### Step 1: Project Initialization

```bash
# Check project status
make status

# Initialize if needed
make init

# View available commands
make help
```

### Step 2: Web Search Strategy

When searching for academic references:

**Search Queries to Use**:

- `"[topic]" systematic review 2023 2024`
- `"[topic]" clinical trial recent results`
- `"[topic]" meta-analysis latest findings`
- `"[topic]" guidelines 2024 update`

**Quality Indicators**:

- DOI present and resolvable
- High-impact journals (Nature, NEJM, Lancet, JAMA, etc.)
- Recent publication dates (2020-2024)
- Systematic reviews over case reports
- Multi-center studies over single-center

**Information to Capture**:

- Full title
- All authors (first 3-5 + "et al." if many)
- Journal name and abbreviation
- Volume, issue, pages
- Publication year
- DOI (essential)
- PubMed ID if available

### Step 3: Citation Integration Process

**A. Manuscript Editing**:

```markdown
# Example integration

Recent studies show improved outcomes [@Smith2024].
Multiple trials confirm this finding [@Smith2024; @Jones2023; @Brown2022].
As demonstrated by Smith et al. [@Smith2024], the treatment...
```

**B. BibTeX Reference Format**:

```bibtex
@article{Smith2024,
  title={Title of the Research Paper},
  author={Smith, John and Jones, Mary and Brown, David},
  journal={Journal of Medical Research},
  volume={45},
  number={3},
  pages={123--135},
  year={2024},
  doi={10.1000/example.2024.123},
  url={https://journal.example.com/article/2024/123}
}
```

### Step 4: Validation and Output Generation

**Run the complete workflow**:

```bash
# Validate all references
make validate

# Convert to outputs
make convert

# Or do both at once
make all
```

**Check validation results**:

```bash
# View validation log
cat output/log.txt

# Check output files
ls output/
```

## 🛠️ Common Tasks and Commands

### For Literature Reviews

```bash
# 1. Initialize with working example
make init

# 2. Research and add 15-30 recent references via WebSearch
# 3. Update manuscript.md with comprehensive content
# 4. Generate outputs
make all
```

### For Original Research Papers

```bash
# 1. Initialize project
make init

# 2. Replace template with research content
# 3. Search for methodology references
# 4. Add discussion citations from recent literature
# 5. Generate final outputs
make all
```

### For Clinical Guidelines

```bash
# 1. Initialize project
make init

# 2. Focus WebSearch on:
#    - Professional society guidelines
#    - Government health agencies
#    - Recent systematic reviews
# 3. Emphasize high-evidence sources
# 4. Generate outputs
make all
```

## 🔍 Web Search Best Practices

### Search Methodology

1. **Start broad, then narrow**:
   - `"cancer treatment 2024"` → `"immunotherapy breast cancer 2024"`

2. **Use medical subject headings**:
   - Include MeSH terms when possible
   - Use official drug names and generic names

3. **Prioritize source types**:
   - Cochrane reviews (highest evidence)
   - Systematic reviews and meta-analyses
   - Randomized controlled trials
   - Clinical guidelines from professional societies
   - Government health agency reports

4. **Validate sources**:
   - Check journal impact factor
   - Verify author affiliations
   - Ensure peer review process
   - Confirm recent publication date

### Reference Quality Checklist

- ✅ DOI resolves correctly
- ✅ Published in peer-reviewed journal
- ✅ Authors from reputable institutions
- ✅ Methods clearly described
- ✅ Appropriate sample size
- ✅ Conflicts of interest declared
- ✅ Recent publication (unless historical context needed)

## 📋 File Management

### Project Structure

```
academic-manuscript-workflow/
├── 📄 manuscript.md              # Working manuscript
├── 📚 reference.bib              # Bibliography database
├── 📋 CLAUDE.md                  # This instruction file
├── 📖 README.md                  # User documentation
├── 📋 Makefile                   # Automation commands
├── 🚫 .gitignore                 # Git exclusions
├── ⚙️ pyproject.toml             # Python configuration
│
├── 📂 scripts/
│   ├── 🔍 validate_references.py # DOI/URL validation
│   └── 📝 ama.csl                # AMA citation style
│
├── 📂 output/                    # Generated files
│   ├── 🌐 manuscript.html        # Web format
│   ├── 📄 manuscript.docx        # Word format
│   └── 📊 log.txt                # Validation log
│
└── 📄 Templates:
    ├── manuscript.template.md     # Manuscript template
    └── reference.template.bib     # Bibliography template
```

### File Purposes

- **`manuscript.md`** - Main working document with citations
- **`reference.bib`** - All references in BibTeX format
- **`output/`** - Generated HTML/DOCX files with formatted citations
- **Templates** - Starting points for new projects

## ⚠️ Important Notes for Claude Code

### Citation Style

- **Uses AMA style** - numbered superscripts in text
- **Vancouver format** bibliography
- **Pandoc citeproc** for processing

### Validation Behavior

- **403 errors are normal** - many publishers block automated requests
- **Focus on DOI validity** - more important than URL accessibility
- **Log all results** - helps users understand validation status

### Error Handling

```bash
# If pandoc fails
make check-deps

# If references invalid
make validate
cat output/log.txt

# If files missing
make status
make init
```

### Dependencies Required

- **Pandoc** - document conversion
- **uv** - Python package management
- **Python 3.9+** - for validation script

## 🎯 Success Criteria

A successful manuscript should have:

- ✅ Proper AMA-style numbered citations
- ✅ Complete bibliography with DOIs
- ✅ Clean HTML and DOCX outputs
- ✅ Validated references (some 403s acceptable)
- ✅ Professional formatting
- ✅ Recent, high-quality sources

## 🚀 Pro Tips for Efficiency

1. **Batch similar tasks**:
   - Search for all methodology references at once
   - Add all discussion citations together
   - Validate references in groups

2. **Use make targets effectively**:

   ```bash
   make validate    # Check references only
   make convert     # Generate outputs only
   make clean       # Reset outputs
   make help        # Show all options
   ```

3. **Leverage templates**:
   - Start with `make init` for working example
   - Modify existing content rather than starting blank
   - Keep successful reference patterns

4. **Quality over quantity**:
   - 15-25 high-quality references > 50 mediocre ones
   - Recent systematic reviews > old individual studies
   - Peer-reviewed > preprints (unless cutting-edge)

---

**Ready to help users**: This workflow enables rapid, professional academic writing with proper citations. Always start with `make init` and use WebSearch extensively to find current, high-quality references.
