all: significances

significances: significances.cc
	g++ --std=c++11 -Wall -Wextra `root-config --libs` -lMinuit `root-config --cflags` `gccflags -incs`\
		significances.cc -o significances
