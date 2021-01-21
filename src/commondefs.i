// modified version of nativelibs/common.i

%{
//#include "bigdecimal.h"
//#include "jprogressmonitor.h"
%}

%exception {
    try {
        $action
    } catch (std::exception& e) {
        SWIG_JavaThrowException(jenv, SWIG_JavaRuntimeException, const_cast<char*>(e.what()));
        return $null;
    }
}

/*--------------------------------------------------------------------------
 * int32 <--> int mapping
 *--------------------------------------------------------------------------*/
%include "platdep/intxtypes.h"

%typemap(jni)    int32_t "jint"
%typemap(jtype)  int32_t "int"
%typemap(jstype) int32_t "int"
%typemap(javain) int32_t "$javainput"
%typemap(javaout) int32_t {
    return $jnicall;
  }

/*--------------------------------------------------------------------------
 * int64 <--> long mapping
 *--------------------------------------------------------------------------*/
%typemap(jni)    int64_t "jlong"
%typemap(jtype)  int64_t "long"
%typemap(jstype) int64_t "long"
%typemap(javain) int64_t "$javainput"
%typemap(javaout) int64_t {
    return $jnicall;
  }

/*--------------------------------------------------------------------------
 * void* <--> long mapping
 *--------------------------------------------------------------------------*/
%typemap(jni)    void* "jlong"
%typemap(jtype)  void* "long"
%typemap(jstype) void* "long"
%typemap(javain) void* "$javainput"
%typemap(javaout) void* {
    return $jnicall;
  }


/*--------------------------------------------------------------------------
 * add utility methods to std::vector wrappers
 *--------------------------------------------------------------------------*/
namespace std {

%typemap(javacode) vector<int> %{
  public int[] toArray() {
    int[] a = new int[(int)size()];
    for (int i=0; i<a.length; i++)
       a[i] = get(i);
    return a;
  }
%}
%typemap(javacode) vector<string> %{
  public String[] toArray() {
    String[] a = new String[(int)size()];
    for (int i=0; i<a.length; i++)
       a[i] = get(i);
    return a;
  }
%}

}

/*--------------------------------------------------------------------------
 * IProgressMonitor
 *--------------------------------------------------------------------------*/
/*
%typemap(jni)    IProgressMonitor * "jobject"
%typemap(jtype)  IProgressMonitor * "org.eclipse.core.runtime.IProgressMonitor"
%typemap(jstype) IProgressMonitor * "org.eclipse.core.runtime.IProgressMonitor"
%typemap(javain) IProgressMonitor * "$javainput"
%typemap(in) IProgressMonitor * (JniProgressMonitor jProgressMonitor) {
   if ($input)
   {
      jProgressMonitor = JniProgressMonitor($input, jenv);
      $1 = &jProgressMonitor;
   }
   else
   {
      $1 = NULL;
   }
}
*/

/*
 * Macro to add equals() and hashCode() to generated Java classes
 */
%define ADD_CPTR_EQUALS_AND_HASHCODE(CLASS)
%typemap(javacode) CLASS %{
  public boolean equals(Object obj) {
    if (this == obj)
      return true;
    if (obj == null || this.getClass() != obj.getClass())
      return false;
    return getCPtr(this) == getCPtr((CLASS)obj);
  }

  public int hashCode() {
    return (int)getCPtr(this);
  }
%}
%enddef
