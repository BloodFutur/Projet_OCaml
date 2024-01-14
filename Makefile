.PHONY: all build format edit demo clean

src?=0
dst?=12
graph?=input2.txt

DOT := $(shell which dot)

all: build

build:
	@echo "\n   🚨  COMPILING  🚨 \n"
	dune build src/ftest.exe
	ls src/*.exe > /dev/null && ln -fs src/*.exe .

format:
	ocp-indent --inplace src/*

edit:
	code . -n

demo: build
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./ftest.exe graphs/${graph} $(src) $(dst) outfile
	@echo "\n   🥁  RESULT (content of outfile)  🥁\n"
	@cat outfile

schedule:
	@echo "\n   🚨  COMPILING  🚨 \n"
	dune build src/scheduletest.exe
	ls src/*.exe > /dev/null && ln -fs src/*.exe .

	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./scheduletest.exe exam_schedule/inputs/${graph} outfile
	@echo "\n   🥁  RESULT (content of outfile)  🥁\n"
	@cat outfile
ifdef DOT
	@dot -Tsvg exam_schedule/output/flow.txt > exam_schedule/output/flow.svg  
	@dot -Tsvg exam_schedule/output/original.txt > exam_schedule/output/original.svg  
	@dot -Tsvg exam_schedule/output/simplified.txt > exam_schedule/output/simplified.svg  
else 
	@echo Dot not found
endif

svg: demo
	@echo "\n   ⚡  SVG  ⚡\n"
	dot -Tsvg outfile > graphs/output.svg

clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	rm -f exam_schedule/output/*.svg
	rm -f exam_schedule/output/*.csv
	rm -f graphs/*.svg
	dune clean
