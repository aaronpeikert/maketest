# Tasks is the first level of parallelisation
# it is the more inefficient way
# but each task can be executed on a different machine (TARDIS)
NTASKS = 4
# Cores is the second level it may or maybe not utilised by OUTSCRIPT
NCORES = 1
# A directory with one file per tasks that specifies the execution of OUTSCRIPT
INDIR = data/settings
# A script that fills INDIR
INSCRIPT = settings.R
# A directory that contains one corresponding file per file in INDIR
OUTDIR = data/results
# A script that uses specifications from INDIR to generate results
OUTSCRIPT = script.R
# The used file extension
SUFFIX = .txt

all: $(INDIR) $(OUTDIR)

indir: $(INDIR)

$(INDIR): $(INSCRIPT)
	Rscript --vanilla $< $(NTASKS)

outdir: $(INDIR) $(OUTDIR)
RESULTS = $(addprefix $(OUTDIR)/, $(notdir $(wildcard $(INDIR)/*$(SUFFIX))))
$(OUTDIR): $(RESULTS)
$(OUTDIR)/%$(SUFFIX): $(INDIR)/%$(SUFFIX)
	Rscript --vanilla $(OUTSCRIPT) $<

reset:
	rm -rf $(OUTDIR)
	rm -rf $(INDIR)

# use `make print-anyvariable` to inspect the value of any variable
print-%: ; @echo $* = $($*)
