;; focus-change-hooks.el --- Provides a hook called once on focus change

;; Author: Hauke Rehfeld
;; Version: 0.1
;; Package-Requires: ((emacs "26.1"))
;; Keywords: hooks, focus, frames

;;; Commentary:
;; This package introduces `focus-change-hooks` that is
;; called exactly once when focus changes, with the previously focused
;; frame no longer in focus.

;;; Code:

(defvar focus-change-hooks-timer-cancel-time 1
  "Time in seconds after which the focus-change-hooks-timer is canceled.")

(defvar focus-change-hooks-last-focused-frame nil "Last frame that was selected.")
(defvar focus-change-hooks-focused-frame nil "Frame that is currently focused.")


(defvar focus-change-hooks-before-hook nil
  "Hook called exactly once when the focus changes.")
(defvar focus-change-hooks-after-hook nil
  "Hook called exactly once when the focus changes.")

(defun focus-change-hooks-run ()
  "Run `focus-change-hooks-before-hook` if the focus has changed."
  ;;(message "focus-change-hooks-run %S (%s) %S" (selected-frame) (frame-live-p (selected-frame)) (cl-find-if (lambda (frame) (eq (frame-focus-state frame) t)) (frame-list)) focus-change-hooks-last-focused-frame)
  (let ((current-focused-frame (selected-frame)))
    (unless (eq current-focused-frame focus-change-hooks-focused-frame)
      (message "!!!!saving last-frame %S <- %S <- %S" current-focused-frame focus-change-hooks-focused-frame focus-change-hooks-last-focused-frame)

      (setq focus-change-hooks-last-focused-frame focus-change-hooks-focused-frame)
      (setq focus-change-hooks-focused-frame current-focused-frame)
      (when (frame-live-p focus-change-hooks-last-focused-frame)
        (message "!!!!running before-hook")
        (with-selected-frame focus-change-hooks-last-focused-frame
          (run-hooks 'focus-change-hooks-before-hook)))
      (when (frame-live-p focus-change-hooks-focused-frame)
        (message "!!!!running after-hook")
        (with-selected-frame focus-change-hooks-focused-frame
          (run-hooks 'focus-change-hooks-after-hook))))))

(add-function :after after-focus-change-function #'focus-change-hooks-run)
;;(remove-function after-focus-change-function #'focus-change-hooks-run)
;; (describe-variable 'after-focus-change-function)
;;(focus-change-hooks--cancel-timer)

(provide 'focus-change-hooks)

;;; focus-change-hooks.el ends here
