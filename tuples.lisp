;;;; tuples.lisp

(in-package :cl-tuples)


(defmacro def-tuple (type-name)
  "Create an alias for values for this tuple.eg (vector3d-tuple #{ 1.0 0.0 0.0 })"
  (tuple-expansion-fn type-name :def-tuple))

(defmacro def-tuple-getter (type-name)
  "Create an access macro such as (vector3d vec) that takes an instance of an array and unpacks it to tuples (aka multiple values)"
  (tuple-expansion-fn type-name :def-tuple-getter))

(defmacro def-tuple-aref (type-name)
  "Create a tuple aref macro for unpacking individual tuple from an array of tuples. eg (vector3d-aref up 5) => (values 0.0 1.0 0.0)"
  (tuple-expansion-fn type-name :def-tuple-aref))

(defmacro def-with-tuple (type-name)
  "Create a macro that can be used to bind members of a value tuple to symbols to symbols e-g (with-vector thing-vec (x y z w)  &body forms)"
  (tuple-expansion-fn type-name :def-with-tuple))

(defmacro def-with-tuple* (type-name)
  "Create a macro that can be used to bind members of the tuples array to symbols to symbols e-g (with-vector* thing-vec #(x y z w)  &body forms)"
  (tuple-expansion-fn type-name :def-with-tuple*))

(defmacro def-with-tuple-aref (type-name)
  "Create a macro that can be used to bind elements of an array of tuples to symbols to symbols e-g (with-vector3d-aref (thing-vec 5 (x y z w))  (+ x y z w))"
  (tuple-expansion-fn type-name :def-with-tuple-aref))

(defmacro def-tuple-setter (type-name)
  "Creates a tuple-setter for setting a tuple array from a mutiple-value tuple. eg (vector3d-setter up #{ 0.0 1.0 0.0 })"
  (tuple-expansion-fn type-name :def-tuple-setter))

(defmacro def-tuple-aref-setter (type-name)
  "Create an aref-setter macro for setting an element in an array of tuples  from a multiple-value tuple. eg (vector3d-aref-setter up 2 #{ 0.0 1.0 0.0 })"
  (tuple-expansion-fn type-name :def-tuple-aref-setter))

(defmacro def-tuple-vector-push (type-name)
    (tuple-expansion-fn type-name :def-tuple-vector-push))

(defmacro def-tuple-vector-push-extend (type-name)
    (tuple-expansion-fn type-name :def-tuple-vector-push-extend))

(defmacro def-new-tuple (type-name)
  "Create a function to create an array suitable for holding an individual tuple. eg (new-vector3d)"
  (tuple-expansion-fn type-name :def-new-tuple))

(defmacro def-tuple-maker (type-name)
  "Create a function to create an array suitable for holding an individual tuple, and initialise elements from multiple-value tuple. eg (make-vector3d (values 1.0 2.0 2.0 ))"
  (tuple-expansion-fn type-name :def-tuple-maker))

(defmacro def-tuple-maker* (type-name)
  "Create a function to create an array suitable for holding an individual tuple, and initialise elements from array tuple. eg (make-vector3d* #( 1.0 2.0 2.0 ))"
  (tuple-expansion-fn type-name :def-tuple-maker*))

(defmacro def-tuple-array-maker (type-name)
  "Create a function to create an array suitable for holding an number of individual tuples. ie an array of array tuples. eg (make-vector3d-array 5 :adjustable t)"
  (tuple-expansion-fn type-name :def-tuple-array-maker))

(defmacro def-tuple-array-dimensions (type-name)
  "Create a function that will return the number of tuples in the array of array tuples."
  (tuple-expansion-fn type-name :def-tuple-array-dimensions))

(defmacro def-tuple-setf (type-name)
  "Create generalised variable macros for tuple of type-name with the given elements."
  (tuple-expansion-fn type-name :def-tuple-setf))

(defmacro def-tuple-array-setf (type-name)
  (tuple-expansion-fn type-name :def-tuple-array-setf))

(defmacro def-tuple-map (type-name)
  "Creates a macro called maps-{tuple-type}-values. Which maps a the
function across a list of values, where it expects to recieve the same
number of values as the named type.
e.g (def-tuple-map vector2d) produces (map-vector2d-values fn &rest values)"
  (tuple-expansion-fn type-name :def-tuple-map))

(defmacro def-tuple-reduce (type-name)
  "Creates a macro called reduce-{tuple-type}-values. Which applies the reduction function to each value in it's second parameter, where it expects to recieve the same number of values as the named type. e.g (def-tuple-reduce vector2d) produces (reduce-vector2d-values fn tuples)"
  (tuple-expansion-fn type-name :def-tuple-reduce))

(defun document-tuple-type (type-name)  
  `(progn
     ;; instead of setf, need some form that can use the symbol in the format
     (setf (documentation ',(tuple-symbol type-name :def-tuple) 'function)
           (format nil "Convert ~A forms to multiple values." ,type-name))
     (setf (documentation ',(tuple-symbol type-name :def-tuple-getter) 'function)
           (format nil "Unpack array representation of an ~A and convert to multiple values." ,type-name))
     (setf (documentation ,'(tuple-symbol type-name :def-tuple-aref) 'function)
           (format nil "Unpack individual ~A to multiple values from an array of ~As." ,type-name ,type-name))                
     (setf (documentation ',(tuple-symbol type-name :def-with-tuple) 'function)
           (format nil "Bind elements of a ~A multiple value to symbols."  ,type-name))
     (setf (documentation ',(tuple-symbol type-name :def-with-tuple*) 'function)
           (format nil "Bind elements of a ~A vector to symbols."  ',type-name))     
     (setf (documentation ',(tuple-symbol type-name :def-with-tuple-aref) 'function)
           (format nil  "Bind the elements of a ~A from vector of ~A's to symbols"))
     (setf (documentation ',(tuple-symbol type-name :def-tuple-setter) 'function)
           (format nil "Creates a macro for setting an ~A vector from a multiple values ~A" ,type-name ,type-name))
     (setf (documentation ',(tuple-symbol type-name :def-tuple-aref-setter) 'function)
           (format nil "Creates a macro for setting an ~A vector in a vector of ~As from a multiple values ~A" ,type-name ,type-name ,type-name))
     (setf (documentation ',(tuple-symbol type-name :def-tuple-vector-push) 'function)
           (format nil "Push a ~A multiple value onto the end of a vector of ~A's ", type-name ,type-name))
     (setf (documentation ',(tuple-symbol type-name :def-tuple-vector-push-extend) 'function)
           (format nil  "Push a ~A multiple value onto the end of a vector of ~A's with the possibility of extension", type-name ,type-name))
     (setf (documentation ',(tuple-symbol type-name :def-new-tuple) 'function)
           (format nil  "Create an array suitable for holding a single ~A" ,type-name))
     (setf (documentation ',(tuple-symbol type-name :def-tuple-maker) 'function)
           (format nil  "Create an array sutable for holding a single ~A and initialize it from a multiple-values form" ,type-name))
     (setf (documentation ',(tuple-symbol type-name :def-tuple-maker*) 'function)
           (format nil   "Create an array sutable for holding a single ~A and initialize it from a  form" ,type-name))
     (setf (documentation ',(tuple-symbol type-name :def-tuple-array-maker) 'function)
           (format nil  "Create an array suitable for holding a number of ~A's " ,type-name))
     (setf (documentation ,'(tuple-symbol type-name :def-tuple-array-dimensions) 'function)
           (format nil  "Return the size of a vector of ~A's (ie how many ~A's it contains)" ,type-name ,type-name))
     (setf (documentation ',(tuple-symbol type-name :def-tuple-map) 'function)
           (format nil  "Map a function over an arbitrary number of ~A's expressed as multiple values and return a ~A mutiple value" ,type-name ,type-name ,type-name))     
     (setf (documentation ',(tuple-symbol type-name :def-tuple-reduce) 'function)
           (format nil "Reduce a ~A to a single value (the same type as it's element) by repated application of the function" ,type-name))))

(defmacro make-tuple-operations (type-name)
  `(progn
     (def-tuple ,type-name)
     (def-tuple-array-dimensions ,type-name)
     (def-tuple-getter ,type-name)
     (def-tuple-aref ,type-name)
     (def-with-tuple ,type-name)
     (def-with-tuple* ,type-name)
     (def-with-tuple-aref ,type-name)
     (def-tuple-setter  ,type-name)
     (def-tuple-aref-setter  ,type-name)
     (def-tuple-vector-push ,type-name)
     (def-tuple-vector-push-extend ,type-name)
     (def-new-tuple ,type-name)
     (def-tuple-maker ,type-name)
     (def-tuple-maker* ,type-name)
     (def-tuple-array-maker ,type-name)
     (def-tuple-setf  ,type-name)
     (def-tuple-array-setf  ,type-name)
     (def-tuple-map ,type-name)
     (def-tuple-reduce ,type-name)))

(defmacro export-tuple-operations (type-name)
  `(progn 
     ,@(loop for kw in *tuple-expander-keywords* collect `(export (tuple-symbol (quote ,type-name) ,kw)))))


;; possibly we also need a deftype form to describe a tuple array?

(defmacro def-tuple-type (tuple-type-name &key tuple-element-type elements)
  "Create a tuple type. To be used from the top level. 
 For example (def-tuple-type vector3d single-float (x y z)) will create several macros and functions. Firstly, the accessor functions (vector3d array) (vector3d-aref array index). Secondly,  the context macros (with-vector3d tuple (element-symbols) forms..) and  (with-vector3d-array tuple (element-symbols) index forms..),  thirdly the constructors (new-vector3d) and (make-vector3d tuple),  (make-vector3d-array dimensions &key adjustable fill-pointer), forthly generalised access as in  (setf (vector3d array) tuple) and (setf (vector3d-aref array) index tuple), fiftly and finally, the  funcional macros (map-vector3d fn tuples..) (reduce-vector3d fn tuple)."
  `(eval-when (:compile-toplevel :execute :load-toplevel)
     (make-tuple-symbol ',tuple-type-name ',tuple-element-type ',elements)
     (make-tuple-operations ,tuple-type-name)     
     (document-tuple-type ',tuple-type-name)))


;; full syntax (def-tuple-op name ((name type (elements)) ..) (
;; this needs some way of having the names as meaningful symbols
;; also a way of specifying type of return value and non-tuple parameters
(defmacro def-tuple-op (name args &body forms)
  "Macro to define a tuple operator. The name of the operator is
   name. The operator arguments are determined by args, which is a
   list of the form ((argument-name argument-type (elements)   ..)). 
   Within the forms the tuple value form is bound to the argument-name 
   and the tuple elements are bound to the symbols in the element list"
  (let ((arg-names (mapcar #'car args))
        (arg-typenames (mapcar #'cadr  args))
        (arg-elements (mapcar #'caddr args)))             
    `(defmacro ,name ,arg-names 
      ,(arg-expander-fn arg-names arg-typenames arg-elements forms))
    (when (stringp (first forms))
      `(setf (documentation ',name 'function) ,(first forms)))))


