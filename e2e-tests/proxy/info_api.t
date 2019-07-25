  $ source ${TESTDIR}/setup_test_env.sh
  $ cd ${TESTTMP}

  $ git clone -q http://${TESTUSER}:${TESTPASS}@localhost:8001/real_repo.git
  warning: You appear to have cloned an empty repository.

  $ cd real_repo

  $ git status
  On branch master
  
  No commits yet
  
  nothing to commit (create/copy files and use "git add" to track)

  $ mkdir sub1
  $ echo contents1 > sub1/file1
  $ git add sub1
  $ git commit -m "add file1"
  [master (root-commit) *] add file1 (glob)
   1 file changed, 1 insertion(+)
   create mode 100644 sub1/file1

  $ mkdir sub2
  $ echo contents1 > sub2/file2
  $ git add sub2
  $ git commit -m "add file2"
  [master *] add file2 (glob)
   1 file changed, 1 insertion(+)
   create mode 100644 sub2/file2


  $ git push
  To http://localhost:8001/real_repo.git
   * [new branch]      master -> master

Get /info/refs to trigger rebuilding and pass credentials
  $ curl -s http://${TESTUSER}:${TESTPASS}@localhost:8002/real_repo.git:/sub1.git/info/refs
  *\trefs/drafts/master (esc) (glob)
  *\trefs/for/master (esc) (glob)
  *\trefs/heads/master (esc) (glob)

  $ curl -s http://localhost:8002/real_repo.git:/sub1.json@refs/heads/master
  {"original":{"commit":"*","parents":[{"commit":"*","tree":"*"}],"tree":"*"},"transformed":{"commit":"*","parents":[],"tree":"*"}} (glob)

  $ bash ${TESTDIR}/destroy_test_env.sh