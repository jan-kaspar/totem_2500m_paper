all: elastic_2500m_epjc.bbl
	pdflatex elastic_2500m_epjc.tex

elastic_2500m_epjc.bbl : bibliography.bib
	bibtex elastic_2500m_epjc.aux

full:
	pdflatex elastic_2500m_epjc.tex
	bibtex elastic_2500m_epjc.aux
	pdflatex elastic_2500m_epjc.tex
	pdflatex elastic_2500m_epjc.tex
