all: elastic_2500m_cern.bbl
	pdflatex elastic_2500m_cern.tex

elastic_2500m_cern.bbl : bibliography.bib
	bibtex elastic_2500m_cern.aux
