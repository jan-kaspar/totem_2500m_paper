all: elastic_2500m_cern.bbl
	pdflatex elastic_2500m_cern.tex

elastic_2500m_cern.bbl : bibliography.bib
	bibtex elastic_2500m_cern.aux

full:
	pdflatex elastic_2500m_cern.tex
	bibtex elastic_2500m_cern.aux
	pdflatex elastic_2500m_cern.tex
	pdflatex elastic_2500m_cern.tex
