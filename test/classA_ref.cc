class classA : public classB, public classC {
/** @class classA
 * @ingroup test
 * @brief help for classA
 *
 * bigger help for classA
 */
protected:
  matlabtypesubstitute mixed_access;
/** @var mixed_access
 * @brief short help
 */

/** @brief longer help with default value
 */
  matlabtypesubstitute mixed_access2 = 'test';

  static const matlabtypesubstitute aConstant = 1;
/** @var aConstant
 * @brief help text
 */

/** @brief help text for bConstant
 */
  static const matlabtypesubstitute bConstant = 2;

  static const matlabtypesubstitute cConstant = 3;
/** @var cConstant
 * @brief help text for cConstant
 */

public:
  matlabtypesubstitute public_access;
/** @var public_access
 * @brief short help for public_access
 */

/** @brief longer help for public_access2
 */
  matlabtypesubstitute public_access2;

protected:
  matlabtypesubstitute protected_access;
/** @var protected_access
 * @brief short help for protected_access
 */

/** @brief longer help text for protected_access2
 */
  matlabtypesubstitute protected_access2;

public:
  classA() {
  }
/** @fn classA::classA()
 * @brief default constructor
 */

  classA(matlabtypesubstitute param1, matlabtypesubstitute param2) {
  }
/** @fn classA::classA(matlabtypesubstitute param1, matlabtypesubstitute param2)
 * @brief bigger constructor
 */

protected:
/* ret::substitutestart::value::retsubstituteend = protected_access(matlabtypesubstitute this) {
}
*/
/** @var classA::protected_access
 * @par Getter is implemented:
 * getter enriching property help text of protected_access
 */

/* noret::substitute protected_access(matlabtypesubstitute this, matlabtypesubstitute value) {
}
*/
/** @var classA::protected_access
 * @par Setter is implemented:
 * setter enriching property help text of protected_access
 */

public:
  static rets::substitutestart::a::b::retssubstituteend static_method(matlabtypesubstitute c) {
  }
/** @fn rets::substitutestart::a::b::retsubstituteend classA::static_method(matlabtypesubstitute c)
 * @brief a static method
 */

  ret::substitutestart::a::retsubstituteend abstract_method(matlabtypesubstitute d) = 0;
/** @fn ret::substitutestart::a::retsubstituteend classA::abstract_method(matlabtypesubstitute d)
 * @brief an abstract method
 */

/*events
end*/

}

