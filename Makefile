# Tasks is the first level of parallelisation
NTASKS = 4
# Cores is the second level of parallelisation which OUTSCRIPT may utilise
NCORES = 1
# A directory with one file per tasks that specifies the execution of OUTSCRIPT
INDIR = data/settings
# A script that fills INDIR
INSCRIPT = settings.R
# A directory that contains one corresponding file in PUTDIR per file in INDIR
OUTDIR = data/results
# A script that uses specifications from INDIR to generate results
OUTSCRIPT = script.R
# The used file extension for files in INDIR/OUTDIR
SUFFIX = .txt

all: $(INDIR) $(OUTDIR)

input: $(INDIR)

$(INDIR): $(INSCRIPT)
	Rscript --vanilla $< $(NTASKS)

output: $(INDIR) $(OUTDIR)
# replace the dir stem of the indir with the outdir
# each file in INDIR will therefore correspond exactly to one file in OUTDIR
RESULTS = $(addprefix $(OUTDIR)/, $(notdir $(wildcard $(INDIR)/*$(SUFFIX))))
$(OUTDIR): $(RESULTS)
# since OUTDIR depends on RESULTS make searches for an implicit rule to
# generate each element in RESULTS
# this rule calls for OUTSCRIPT with the corresponding file in INDIR as argument
$(OUTDIR)/%$(SUFFIX): $(INDIR)/%$(SUFFIX)
	Rscript --vanilla $(OUTSCRIPT) $<

reset:
	rm -rf $(OUTDIR)
	rm -rf $(INDIR)

# use `make print-anyvariable` to inspect the value of any variable
print-%: ; @echo $* = $($*)
