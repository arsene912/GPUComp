src = $(wildcard *.cu)
bin = $(patsubst %.cu,%,$(src))

all: $(bin)

%: %.cu
    nvcc -o $@ $<
