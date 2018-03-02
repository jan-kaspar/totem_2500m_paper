all: elastic_2500m_prd.bbl
	pdflatex elastic_2500m_prd.tex

elastic_2500m_prd.bbl : bibliography.bib
	bibtex elastic_2500m_prd.aux

full:
	pdflatex elastic_2500m_prd.tex
	bibtex elastic_2500m_prd.aux
	pdflatex elastic_2500m_prd.tex
	pdflatex elastic_2500m_prd.tex
