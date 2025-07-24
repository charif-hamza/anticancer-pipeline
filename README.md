# Anticancer Metal‑Complex Discovery Pipeline

> **One‑liner:** A fully reproducible, end‑to‑end workflow that designs, filters, and prioritises novel metal‑based anticancer leads—entirely on CPU‑only hardware—using open‑source cheminformatics, machine‑learning, and docking tools.

---

## Table of Contents

1. [Motivation](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#motivation)
    
2. [Features](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#features)
    
3. [Project Roadmap](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#project-roadmap)
    
4. [Repository Layout](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#repository-layout)
    
5. [Installation](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#installation)
    
6. [Quick Start](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#quick-start)
    
7. [Usage Examples](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#usage-examples)
    
8. [Development Workflow](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#development-workflow)
    
9. [Testing](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#testing)
    
10. [Continuous Integration](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#continuous-integration)
    
11. [Reproducibility Checklist](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#reproducibility-checklist)
    
12. [Citing This Work](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#citing-this-work)
    
13. [License](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#license)
    
14. [References](https://chatgpt.com/c/6882704a-2ee4-8330-835d-4a177adc45a4#references)
    

---

## Motivation

Conventional deep‑learning drug‑discovery demos rarely translate to resource‑constrained environments and seldom address the unique chemistry of metal complexes. This project showcases **how far one can go on a CPU‑only laptop** while rigorously following best practices in open science, software engineering, and data ethics.

## Features

- **Generative Ligand Design** via fragment mutation and scaffold hopping (`RDKit`).
    
- **Physicochemical & Medicinal‑Chemistry Filters** (Lipinski, Veber, PAINS, SA Score, custom toxicity rules).
    
- **Metal Complex Assembly** (square‑planar, octahedral, tetrahedral geometries) without heavy QM.
    
- **In‑silico Property Prediction**
    
    - _Option A:_ Inference with state‑of‑the‑art pretrained GNNs (`DeepChem`, `Chemprop`).
        
    - _Option B:_ CPU‑friendly classical ML (Random Forest, XGBoost) on molecular fingerprints.
        
- **Target‑Binding Docking** via `AutoDock Vina` on a curated subset.
    
- **Lead Prioritisation & Clustering** (PCA/t‑SNE, Tanimoto similarity heatmaps).
    
- **Reproducible Environments** powered by **Nix flakes** and declarative lockfiles.
    
- **Command‑Line Interface** (`drugtool`) with sub‑commands for each stage.
    
- **Automated Testing** (`pytest`) and **GitHub Actions** CI.
    
- **Rich, Shareable Report** generated with **Quarto** / Markdown.
    

## Project Roadmap

|Phase|Timeline|Milestones|
|---|---|---|
|**1. Generation & Filtering**|July 2025|Robust RDKit pipeline; ≥10 k ligands filtered to <500 candidates|
|**2. ML Prediction & Docking**|August 2025|Property inference + docking on top 200 candidates; ranked CSV export|
|**3. Analysis & Reporting**|September 2025|Quarto report with visual analytics; release v1.0 preprint|

_(See **[`report/roadmap.qmd`](https://chatgpt.com/c/report/)** for full Gantt chart.)_

## Repository Layout

```
anticancer-pipeline/
├── .github/           # CI workflows
├── data/
│   ├── raw/           # Untouched source datasets
│   ├── processed/     # Post‑filtering datasets (git‑ignored)
│   └── docking/       # Vina input/output (git‑ignored)
├── notebooks/         # Exploratory analysis (Jupyter / Quarto)
├── report/            # Manuscript, figures, tables
├── src/
│   ├── main.py        # Entry‑point wrapper
│   └── drugtool/      # Library + CLI
│       ├── __init__.py
│       ├── cli.py     # Typer‑based CLI
│       ├── generator.py
│       ├── filters.py
│       ├── predict.py
│       ├── dock.py
│       └── analysis.py
├── tests/             # Unit + integration tests
├── flake.nix          # Top‑level Nix flake
└── flake.lock
```

> **Tip:** All heavy artefacts are excluded via `.gitignore` and cached with `dvc` (optional).

## Installation

### Prerequisites

- **Nix 2.19+** with flakes enabled _(recommended)_
    
- OR Python 3.11+, [`poetry`](https://python-poetry.org/) for a virtual‑env workflow
    
- Linux/macOS; Windows via WSL2
    

### With Nix (1‑liner)

```bash
nix develop github:<your‑org>/anticancer-pipeline#devShell
```

This drops you into a shell where **all** dependencies—Python, RDKit, AutoDock Vina, etc.—are pinned and reproducible.

### Without Nix (Poetry)

```bash
git clone https://github.com/<your‑org>/anticancer-pipeline.git
cd anticancer-pipeline
poetry install --with dev
poetry shell
```

> ⚠️ **Note:** You must install AutoDock Vina separately and ensure it is on your `PATH`.

## Quick Start

1. **Generate & filter ligands**
    
    ```bash
    drugtool generate --seed scaffolds.smi --out data/processed/ligands.smi
    ```
    
2. **Predict cytotoxicity** (pre‑trained model)
    
    ```bash
    drugtool predict --in data/processed/ligands.smi --model pretrained/chemprop.pt \
                     --out data/processed/predictions.csv
    ```
    
3. **Dock top 100**
    
    ```bash
    drugtool dock --in data/processed/predictions.csv --receptor pdbs/5lsd.pdbqt \
                  --out data/docking/results.csv --top 100
    ```
    
4. **Analyse & report**
    
    ```bash
    drugtool analyse --pred data/processed/predictions.csv --dock data/docking/results.csv \
                     --report report/lead_selection.qmd
    quarto render report/lead_selection.qmd
    ```
    

## Usage Examples

See the full CLI reference:

```bash
drugtool --help
```

or browse the Jupyter/Quarto notebooks in [`notebooks/`](https://chatgpt.com/c/notebooks/).

## Development Workflow

|Task|Command|
|---|---|
|Format + import sort|`ruff check --fix src tests`|
|Static typing|`mypy src`|
|Unit tests|`pytest -q`|
|Coverage report|`pytest --cov=drugtool`|
|Lint (pre‑commit hook)|`pre‑commit run --all-files`|

> **Dev Shell:** All these tools are pre‑installed when you run `nix develop` or `poetry install --with dev`.

## Testing

Tests live in `tests/` and are automatically executed in CI on each push and Pull Request.

```bash
pytest -q
```

## Continuous Integration

GitHub Actions workflow at `.github/workflows/ci.yml` runs:

1. Nix flake evaluation (caching via `cachix`).
    
2. Linting + type checks.
    
3. Unit tests on Ubuntu 22.04 and macOS.
    
4. Publish documentation (GitHub Pages) on `main` pushes.
    

## Reproducibility Checklist

## Citing This Work

If you use this pipeline in academic or industrial research, please cite:

```bibtex
@misc{antiMetal2025,
  author       = {Charif Hamza},
  title        = {Anticancer Metal‑Complex Discovery Pipeline},
  howpublished = {GitHub},
  year         = {2025},
  url          = {https://github.com/charif-hamza/anticancer-pipeline},
}
```

## License

Distributed under the **MIT License**. See [`LICENSE`](https://chatgpt.com/c/LICENSE) for details.

## References

1. Landrum, G. _RDKit: Open‑Source Cheminformatics_ (2006–2025).
    
2. Stokes, J. _et al._ Chemprop: Machine Learning with Molecule Graphs (2020).
    
3. Trott, O.; Olson, A. _AutoDock Vina: Improving the Speed and Accuracy of Docking_ (2010).
    
4. Lipinski, C. _et al._ Experimental and Computational Approaches to Estimate Solubility and Permeability (1997).
    

> _Made with ❤ and a ThinkPad._
