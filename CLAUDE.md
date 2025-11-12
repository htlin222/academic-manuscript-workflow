# Citation Workflow for Claude Code

## Simple Workflow

When user says "read the CLAUDE.md, start your job":

1. **Read manuscript.md** - Find numbered citations (1, 2, 3, etc.)
2. **Convert citations** - Change numbers to `[@AuthorYear]` format
3. **Add to reference.bib** - Create BibTeX entries for each citation
4. **Generate output** - Run `make all` to create formatted documents

## Step-by-Step Process

### Step 1: Read Current Manuscript

```bash
# Read the manuscript to find what needs citations
cat manuscript.md
```

### Step 2: Identify What Needs Citations

**Case A: Numbered citations exist**

- Look for: `cancer.1`, `trials.3-5`, `analysis.6`
- Convert numbers to `[@AuthorYear]` format

**Case B: Plain text without citations**

- Look for factual claims that need support:
  - Statistics: "30% of patients...", "Studies show..."
  - Medical facts: "Treatment improves outcomes"
  - Guidelines: "Standard care includes..."
  - Research findings: "Results demonstrate..."
- Add citations where evidence is needed

### Step 3: Search for Appropriate References

For each claim needing citation:

1. **Use WebSearch** with specific terms
2. **Search patterns**:
   - `"breast cancer survival rates 2024"`
   - `"postmastectomy radiotherapy guidelines"`
   - `"stage II breast cancer treatment"`
3. **Find quality sources**: Recent papers, guidelines, systematic reviews

### Step 4: Convert to Citation Format

**From numbered**: `cancer.1` → `cancer [@Smith2024].`
**Add new**: `Survival rates improve` → `Survival rates improve [@Johnson2024].`

### Step 5: Create BibTeX Entries

Add to `reference.bib`:

```bibtex
@article{Smith2024,
  title={Title from web search},
  author={Smith, John and Jones, Mary},
  journal={Journal Name},
  year={2024},
  doi={10.1000/example}
}
```

### Step 6: Generate Final Documents

```bash
make all
```

## Web Search Tips

When searching for references:

- Use WebSearch tool to find recent papers (2020+)
- Search: `"[topic]" systematic review 2024`
- Get DOI numbers for each reference
- Prioritize high-impact journals (Nature, NEJM, Lancet)

## Example Citation Conversion

Current manuscript has: `cancer.1`

1. **Search** for the paper using WebSearch
2. **Convert** to: `cancer [@Smith2024].`
3. **Add BibTeX**:

```bibtex
@article{Smith2024,
  title={Breast Cancer Treatment Guidelines},
  author={Smith, John and Jones, Mary},
  journal={New England Journal of Medicine},
  year={2024},
  doi={10.1056/NEJMoa2024123}
}
```

## Commands

```bash
make all     # Generate final documents
make validate # Check references
make help    # Show all options
```
