import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import {spawnSync} from 'node:child_process';
import {REPO_ROOT} from './lib/db.mjs';
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'dedupe-demo-'));
const env={...process.env,DATABASE_URL:'',DATA_DIR:path.join(dir,'db'),OUTPUT_DIR:dir};
const run=(file,args=[])=>{const r=spawnSync(process.execPath,[path.join(REPO_ROOT,'scripts',file),...args],{env,encoding:'utf8'});if(r.status!==0)throw Error(r.stderr||r.stdout);return r.stdout;};
try {run('migrate.mjs');run('seed.mjs');const captures=[];for(const [cmd,title,ask] of [['attention','The review queue','Which duplicate groups need attention?'],['conflicts','Field disagreements','Where do the duplicate records disagree?'],['owners','Reviewer workload','Who has duplicate reviews waiting?']]){const output=run('dedupe.mjs',[cmd]);console.log(output);captures.push({title,ask,command:`node scripts/dedupe.mjs ${cmd}`,output:output.trimEnd()});}console.log(run('view.mjs'));console.log(run('docs.mjs'));fs.writeFileSync(path.join(dir,'captures.json'),JSON.stringify(captures,null,2));if(process.argv.includes('--keep'))console.log(`DEMO_DIR=${dir}`);}finally{if(!process.argv.includes('--keep'))fs.rmSync(dir,{recursive:true,force:true});}
