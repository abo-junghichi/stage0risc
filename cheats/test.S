#define rel(reg,label) 81 reg label
#define mv(src,dst) 89 src dst src
#define label(name) :##name
:no_one_refer	# define label.
:		# empty name is allowed.
label()
81 23 +data	# (+|-)name emits relative-addressing field.
rel(23,+data)	# +name refers nearest forward label.
label(data)
81 FA -		# -name refers for backward.
rel (FA,-)	# can refer labels with empty name.
mv(23,21)
++data		# (++|--)name emits relative-addressing with 4byte.
--
:data		# allowing duplicated labels and refering nearest acts
		# friendly with macros.
