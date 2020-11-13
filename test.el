;;; test.el --- description -*- lexical-binding: t; -*-

(defun path= (p1 p2)
  "Test if two paths P1 and P2 are equal."
  (string= (expand-file-name p1)
           (expand-file-name p2)))

;;; dominating Cargo.toml method
(defun cargo-workspace-1 (source-file)
  (locate-dominating-file source-file "Cargo.toml"))

(path= (cargo-workspace-1 "standalone-lib/src/lib.rs")
       "standalone-lib/")

(path= (cargo-workspace-1 "standalone-bin/src/main.rs")
       "standalone-bin/")

;; incorrect
(path= (cargo-workspace-1 "workspace-lib/sub-a/src/lib.rs")
       "workspace-lib/sub-a/")

;; incorrect
(path= (cargo-workspace-1 "workspace-bin/sub-a/src/main.rs")
       "workspace-bin/sub-a/")

(path= (cargo-workspace-1 "non-workspace-nested/nested/src/lib.rs")
       "non-workspace-nested/nested/")

(path= (cargo-workspace-1 "non-workspace-nested/src/lib.rs")
       "non-workspace-nested/")



;;; dominating Cargo.lock method
(defun cargo-workspace-2 (source-file)
  (locate-dominating-file source-file "Cargo.lock"))
;; emulate a fresh checkout
(delete-file "standalone-lib/Cargo.lock")
(delete-file "workspace-lib/Cargo.lock")

;; incorrect
(not (cargo-workspace-2 "standalone-lib/src/lib.rs"))

(path= (cargo-workspace-2 "standalone-bin/src/main.rs")
       "standalone-bin/")

;; incorrect
(not (cargo-workspace-2 "workspace-lib/sub-a/src/lib.rs"))

(path= (cargo-workspace-2 "workspace-bin/sub-a/src/main.rs")
       "workspace-bin/sub-a/")

;; sometimes correct; if you built something. Always incorrect when fresh.
(delete-file "non-workspace-nested/Cargo.lock")
(delete-file "non-workspace-nested/nested/Cargo.lock")
(not (cargo-workspace-2 "non-workspace-nested/nested/src/lib.rs"))
(not (cargo-workspace-2 "non-workspace-nested/src/lib.rs"))
