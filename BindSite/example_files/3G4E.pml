load 3G4E.pdb
disable 3G4E

create 3G4E_A_CA1, (3G4E and resi 1 and chain A) or (3G4E and ((resi 18+103+104+154+204+205+246+324+329+337+359+575+615 and chain A)))
as spheres, 3G4E_A_CA1 and resi 1 and chain A
color yellow, 3G4E_A_CA1 and resi 1 and chain A
as sticks, 3G4E_A_CA1 and ((resi 18+103+104+154+204+205+246+324+329+337+359+575+615 and chain A))
util.cbaw 3G4E_A_CA1 and ((resi 18+103+104+154+204+205+246+324+329+337+359+575+615 and chain A))

zoom all 
create 3G4E_B_CA1, (3G4E and resi 1 and chain B) or (3G4E and ((resi 18+103+104+154+204+205+246+307+344+345+406+729+746+781 and chain B)))
as spheres, 3G4E_B_CA1 and resi 1 and chain B
color yellow, 3G4E_B_CA1 and resi 1 and chain B
as sticks, 3G4E_B_CA1 and ((resi 18+103+104+154+204+205+246+307+344+345+406+729+746+781 and chain B))
util.cbaw 3G4E_B_CA1 and ((resi 18+103+104+154+204+205+246+307+344+345+406+729+746+781 and chain B))

zoom all 
