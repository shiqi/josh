  $ source ${TESTDIR}/setup_test_env.sh
  $ cd ${TESTTMP}
 
 
  $ git clone -q http://${TESTUSER}:${TESTPASS}@localhost:8001/real_repo.git
  warning: You appear to have cloned an empty repository.
 
  $ curl -s http://localhost:8002/version
  Version: * (glob)
 
  $ cd real_repo
 
  $ git status
  On branch master
  
  No commits yet
  
  nothing to commit (create/copy files and use "git add" to track)
 
  $ git checkout -b master
  Switched to a new branch 'master'
 
 
  $ echo content1 > root_file1 &> /dev/null
  $ git add .
  $ git commit -m "initial" &> /dev/null
 
  $ git checkout -b new1
  Switched to a new branch 'new1'
  $ echo content > newfile1 &> /dev/null
  $ git add .
  $ git commit -m "add newfile1" &> /dev/null
 
  $ git checkout master &> /dev/null
  $ echo content > newfile_master &> /dev/null
  $ git add .
  $ git commit -m "newfile master" &> /dev/null
 
  $ git merge new1 --no-ff
  Merge made by the 'recursive' strategy.
   newfile1 | 0
   1 file changed, 0 insertions(+), 0 deletions(-)
   create mode 100644 newfile1
 
 
  $ mkdir -p sub1/subsub
  $ echo contents1 > sub1/subsub/file1
  $ git add .
  $ git commit -m "add file1" &> /dev/null
 
  $ mkdir sub2
  $ echo contents1 > sub2/file2
  $ git add sub2
  $ git commit -m "add file2" &> /dev/null
 
  $ mkdir ws
  $ cat > ws/workspace.josh <<EOF
  > pre/a/b = :/sub2
  > pre/c = :/sub1
  > EOF
 
  $ git add ws
  $ git commit -m "add workspace" &> /dev/null
 
  $ mkdir sub3
  $ echo contents3 > sub3/file3
  $ git add sub3
  $ git commit -m "add file3" &> /dev/null
 
  $ cat > ws/workspace.josh <<EOF
  > pre/a/b = :/sub2
  > pre/c = :/sub1
  > pre/d = :/sub3
  > EOF
 
  $ git add ws
  $ git commit -m "mod workspace" &> /dev/null
 
  $ git log --graph --pretty=%s
  * mod workspace
  * add file3
  * add workspace
  * add file2
  * add file1
  *   Merge branch 'new1'
  |\  
  | * add newfile1
  * | newfile master
  |/  
  * initial
 
 
  $ git push
  To http://localhost:8001/real_repo.git
   * [new branch]      master -> master
 
  $ cd ${TESTTMP}
 
  $ git clone -q http://${TESTUSER}:${TESTPASS}@localhost:8002/real_repo.git:workspace=ws:/pre.git ws
  $ cd ws
  $ tree
  .
  |-- a
  |   `-- b
  |       `-- file2
  |-- c
  |   `-- subsub
  |       `-- file1
  `-- d
      `-- file3
  
  5 directories, 3 files
 
  $ git log --graph --pretty=%s
  *   mod workspace
  |\  
  | * add file3
  * add file2
  * add file1
 
  $ git checkout HEAD~1 &> /dev/null
  $ tree
  .
  |-- a
  |   `-- b
  |       `-- file2
  `-- c
      `-- subsub
          `-- file1
  
  4 directories, 2 files
 
  $ git checkout HEAD~1 &> /dev/null
  $ tree
  .
  `-- c
      `-- subsub
          `-- file1
  
  2 directories, 1 file
 
  $ git checkout master &> /dev/null
 
  $ echo newfile_1_contents > c/subsub/newfile_1
  $ git rm c/subsub/file1
  rm 'c/subsub/file1'
  $ echo newfile_2_contents > a/b/newfile_2
  $ echo ws_file_contents > ws_file
 
  $ git add .
 
  $ git commit -m "add in view" &> /dev/null
 
  $ git push &> /dev/null
 
  $ cd ${TESTTMP}/real_repo
 
  $ git pull &> /dev/null
 
  $ git clean -ffdx &> /dev/null
 
  $ tree
  .
  |-- newfile1
  |-- newfile_master
  |-- root_file1
  |-- sub1
  |   `-- subsub
  |       `-- newfile_1
  |-- sub2
  |   |-- file2
  |   `-- newfile_2
  |-- sub3
  |   `-- file3
  `-- ws
      |-- pre
      |   `-- ws_file
      `-- workspace.josh
  
  6 directories, 9 files
  $ git log --graph --pretty=%s
  * add in view
  * mod workspace
  * add file3
  * add workspace
  * add file2
  * add file1
  *   Merge branch 'new1'
  |\  
  | * add newfile1
  * | newfile master
  |/  
  * initial
 
 
  $ git checkout HEAD~1 &> /dev/null
  $ git clean -ffdx &> /dev/null
  $ tree
  .
  |-- newfile1
  |-- newfile_master
  |-- root_file1
  |-- sub1
  |   `-- subsub
  |       `-- file1
  |-- sub2
  |   `-- file2
  |-- sub3
  |   `-- file3
  `-- ws
      `-- workspace.josh
  
  5 directories, 7 files
  $ cat sub1/subsub/file1
  contents1
 
  $ git checkout HEAD~1 &> /dev/null
  $ git clean -ffdx &> /dev/null
  $ tree
  .
  |-- newfile1
  |-- newfile_master
  |-- root_file1
  |-- sub1
  |   `-- subsub
  |       `-- file1
  |-- sub2
  |   `-- file2
  |-- sub3
  |   `-- file3
  `-- ws
      `-- workspace.josh
  
  5 directories, 7 files
 
 
  $ bash ${TESTDIR}/destroy_test_env.sh

$ cat ${TESTTMP}/josh-proxy.out | grep VIEW
